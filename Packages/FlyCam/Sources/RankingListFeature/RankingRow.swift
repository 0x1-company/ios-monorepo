import SwiftUI

struct RankingRowView: View {
  let rank: Int
  let altitude: Double
  let displayName: String

  @State var translation = CGSize.zero
  @GestureState var dragState: DragState = .inactive

  enum DragState {
    case inactive
    case active(CGSize)

    var translation: CGSize {
      switch self {
      case let .active(translation):
        return translation
      default:
        return .zero
      }
    }
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack(spacing: 0) {
        VStack(spacing: 4) {
          Text("No.\(rank): \(altitude) meter", bundle: .module)
            .frame(maxWidth: .infinity, alignment: .leading)

          Text("by \(displayName)", bundle: .module)
            .foregroundStyle(Color.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.system(.subheadline, weight: .semibold))

        Image(systemName: "ellipsis")
          .foregroundStyle(Color.secondary)
      }
      .frame(height: 56)
      .padding(.horizontal, 16)

      Color.red
        .aspectRatio(3 / 4, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .compositingGroup()
        .overlay {
          GeometryReader { proxy in
            Color.blue
              .aspectRatio(3 / 4, contentMode: .fit)
              .frame(width: proxy.size.width / 3, height: proxy.size.height / 3)
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .offset(
                x: dragState.translation.width + translation.width,
                y: dragState.translation.height + translation.height
              )
              .gesture(
                DragGesture(minimumDistance: 0)
                  .updating($dragState) { value, state, _ in
                    state = .active(value.translation)
                  }
                  .onEnded { value in
                    if value.location.x <= proxy.size.width / 2 {
                      withAnimation(.bouncy) {
                        translation = .zero
                      }
                    } else {
                      withAnimation(.bouncy) {
                        translation = CGSize(width: proxy.size.width / 3 * 2, height: 0)
                      }
                    }
                  }
              )
          }
          .padding(.all, 12)
        }
    }
  }
}

#Preview {
  RankingRowView(
    rank: 1,
    altitude: 1.0,
    displayName: "tomokisun"
  )
}
