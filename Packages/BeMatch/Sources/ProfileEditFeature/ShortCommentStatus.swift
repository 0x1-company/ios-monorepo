import BeMatch
import SwiftUI

struct ShortCommentStatus: View {
  let status: BeMatch.ShortCommentStatus?

  var body: some View {
    switch status {
    case .inReview:
      Text("In Review", bundle: .module)
        .foregroundStyle(Color.yellow)

    case .approved:
      Text("Approved", bundle: .module)
        .foregroundStyle(Color.green)

    case .rejected:
      Text("Rejected", bundle: .module)
        .foregroundStyle(Color.red)

    default:
      Text("No Set", bundle: .module)
    }
  }
}

#Preview {
  NavigationStack {
    List {
      Section {
        ForEach([nil] + BeMatch.ShortCommentStatus.allCases, id: \.self) { status in
          LabeledContent {
            HStack {
              ShortCommentStatus(status: status)
              Image(systemName: "chevron.right")
            }
          } label: {
            Text("Short Comment", bundle: .module)
              .foregroundStyle(Color.primary)
          }
        }
      }

      Section {
        ForEach([nil] + BeMatch.ShortCommentStatus.allCases, id: \.self) { status in
          LabeledContent {
            HStack {
              ShortCommentStatus(status: status)
              Image(systemName: "chevron.right")
            }
          } label: {
            Text("Short Comment", bundle: .module)
              .foregroundStyle(Color.primary)
          }
          .environment(\.locale, Locale(identifier: "ja-JP"))
        }
      }
    }
  }
  .environment(\.colorScheme, .dark)
}
