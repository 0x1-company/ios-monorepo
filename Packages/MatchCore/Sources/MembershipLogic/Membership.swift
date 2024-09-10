import ActivityView
import AnalyticsClient
import API
import APIClient
import Build
import ComposableArchitecture
import EnvironmentClient
import FeedbackGeneratorClient
import ProductPurchaseLogic
import StoreKit
import StoreKitClient
import StoreKitHelpers
import SwiftUI
import TcaHelpers

@Reducer
public struct MembershipLogic {
  public init() {}

  public struct CompletionWithItems: Equatable {
    public let activityType: UIActivity.ActivityType?
    public let result: Bool

    public init(activityType: UIActivity.ActivityType?, result: Bool) {
      self.activityType = activityType
      self.result = result
    }
  }

  @ObservableState
  public struct State: Equatable {
    public var child = Child.State.loading

    var product: StoreKit.Product?

    public var invitationCode = ""

    public var isPresented = false
    @Presents public var destination: Destination.State?

    public var shareText = ""

    public init() {}
  }

  public enum Action: BindableAction {
    case onTask
    case closeButtonTapped
    case response(Result<[Product], Error>, Result<API.MembershipQuery.Data, Error>)
    case onCompletion(CompletionWithItems)
    case child(Child.Action)
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.build) var build
  @Dependency(\.store) var store
  @Dependency(\.analytics) var analytics
  @Dependency(\.environment) var environment
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel {
    case purchase
    case response
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        let ids = build.infoDictionary("PRODUCTS", for: [String].self)!
        return .run { send in
          for try await data in api.membership() {
            await send(.response(Result {
              try await store.products(ids)
            }, .success(data)))
          }
        } catch: { error, send in
          await send(.response(.success([]), .failure(error)))
        }
        .cancellable(id: Cancel.response, cancelInFlight: true)

      case .closeButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.dismiss), animation: .default)
        }

      case .child(.campaign(.delegate(.sendInvitationCode))),
           .child(.campaign(.invitationCodeCampaign(.delegate(.sendInvitationCode)))):
        state.isPresented = true
        return .none

      case .child(.campaign(.delegate(.purchase))),
           .child(.purchase(.delegate(.purchase))):
        state.destination = .purchase(ProductPurchaseLogic.State.loading)
        return .none

      case let .response(.success(products), .success(data)):
        state.invitationCode = data.invitationCode.code

        let campaign = data.activeInvitationCampaign
        let product = products.sorted(by: { $0.price < $1.price }).first
        state.product = product

        if let campaign, let product {
          let productPrice = product.price
          let specialOfferPrice = productPrice * Decimal(campaign.durationWeeks)
          let currencyCode = product.priceFormatStyle.currencyCode
          let specialOfferDisplayPrice = product.priceFormatStyle.attributed.format(specialOfferPrice)

          state.child = .campaign(
            MembershipCampaignLogic.State(
              campaign: campaign,
              code: data.invitationCode.code,
              displayPrice: product.displayPrice,
              displayDuration: formatDuration(campaign.durationWeeks),
              currencyCode: currencyCode,
              specialOfferDisplayPrice: specialOfferDisplayPrice
            )
          )

          let brand = environment.brand()

          let invitationLink = switch brand {
          case .bematch:
            "https://bematch.onelink.me/nob4/mhxumci1"
          case .picmatch:
            ""
          case .tapmatch:
            "https://tapmatch.onelink.me/3cHT/9p06ezpt"
          case .tenmatch:
            "https://tenmatch.onelink.me/Qlqa/2ejn2khj"
          case .trinket:
            "https://trinket.onelink.me/QUNV/eb1vz43z"
          }

          let localized: String.LocalizationValue = """
          I'm sending you an invite code [\(data.invitationCode.code)] to unlock \(brand.displayName) PRO for free (worth \(specialOfferDisplayPrice)).
          \(invitationLink)
          """
          state.shareText = String(localized: localized, bundle: .module)

        } else if let product {
          state.child = .purchase(
            MembershipPurchaseLogic.State(
              displayPrice: product.displayPrice
            )
          )
        }
        return .none

      case let .response(.success(products), .failure):
        guard let product = products.sorted(by: { $0.price < $1.price }).first
        else { return .none }

        state.child = .purchase(MembershipPurchaseLogic.State(displayPrice: product.displayPrice))
        return .none

      case let .onCompletion(completion):
        state.isPresented = false
        analytics.logEvent("invitation_code_completion", [
          "activity_type": completion.activityType?.rawValue ?? "",
          "result": completion.result,
        ])
        return .none

      case .destination(.presented(.alert(.confirmOkay))):
        state.destination = nil
        return .send(.delegate(.dismiss))

      case .destination(.presented(.purchase(.delegate(.dismiss)))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  func formatDuration(_ durationWeeks: Int) -> String {
    if durationWeeks <= 3 {
      return String(localized: "\(durationWeeks) week", bundle: .module)
    }

    let months = durationWeeks / 4
    let remainingWeeks = durationWeeks % 4

    let years = months / 12
    let remainingMonths = months % 12

    var result: [String] = []
    if years > 0 {
      result.append(String(localized: "\(years) year", bundle: .module))
    }
    if remainingMonths > 0 {
      result.append(String(localized: "\(remainingMonths) month", bundle: .module))
    }
    if remainingWeeks > 0 {
      result.append(String(localized: "\(remainingWeeks) week", bundle: .module))
    }

    return result.joined(separator: ", ")
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case loading
      case campaign(MembershipCampaignLogic.State)
      case purchase(MembershipPurchaseLogic.State)
    }

    public enum Action {
      case campaign(MembershipCampaignLogic.Action)
      case purchase(MembershipPurchaseLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.campaign, action: \.campaign) {
        MembershipCampaignLogic()
      }
      Scope(state: \.purchase, action: \.purchase) {
        MembershipPurchaseLogic()
      }
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case alert(AlertState<Action.Alert>)
      case purchase(ProductPurchaseLogic.State = .loading)
    }

    public enum Action {
      case alert(Alert)
      case purchase(ProductPurchaseLogic.Action)

      public enum Alert: Equatable {
        case confirmOkay
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.alert, action: \.alert) {}
      Scope(state: \.purchase, action: \.purchase, child: ProductPurchaseLogic.init)
    }
  }
}
