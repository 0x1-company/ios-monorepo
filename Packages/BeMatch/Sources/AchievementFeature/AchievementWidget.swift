import SwiftUI

struct AchievementWidgetView: View {
  let systemImage: String
  let titleKey: LocalizedStringKey
  let text: LocalizedStringKey

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Label(titleKey, systemImage: systemImage)
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, weight: .semibold))

      Text("999")
        .font(.system(size: 64, weight: .semibold))

      Text(text, bundle: .module)
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, weight: .semibold))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 16)
    .padding(.horizontal, 12)
  }
}
