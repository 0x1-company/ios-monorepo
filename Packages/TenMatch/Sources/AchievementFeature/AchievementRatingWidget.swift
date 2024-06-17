import SwiftUI

struct AchievementRatingWidgetView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("RATING", bundle: .module)
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, design: .rounded, weight: .semibold))

      HStack(spacing: 8) {
        ForEach(0 ..< 5) { _ in
          Image(systemName: "star.fill")
            .font(.system(size: 40))
        }
      }
      .foregroundStyle(Color.yellow)

      VStack(alignment: .leading, spacing: 0) {
        Text("Top")
          .font(.system(size: 20, weight: .semibold, design: .rounded))
        Text("0.1%")
          .font(.system(size: 64, weight: .semibold, design: .rounded))
      }

      Text("Count of swipes across Japan", bundle: .module)
        .foregroundStyle(Color.secondary)
        .font(.system(.headline, design: .rounded, weight: .semibold))
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.vertical, 16)
    .padding(.horizontal, 12)
  }
}

#Preview {
  NavigationStack {
    AchievementRatingWidgetView()
  }
  .environment(\.colorScheme, .dark)
}
