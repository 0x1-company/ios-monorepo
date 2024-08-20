import SwiftUI

struct AchievementWidgetView: View {
  let systemImage: String
  let titleKey: LocalizedStringKey
  let displayCount: String
  let text: String

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Label(titleKey, systemImage: systemImage)
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, weight: .semibold))

      Text(displayCount)
        .font(.system(size: 64, weight: .semibold, design: .rounded))

      Text(text)
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, weight: .semibold))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 16)
  }
}
