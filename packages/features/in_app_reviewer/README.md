# review_prompt

In-app review prompting functionality for One Page diary app.

## Features

- **Smart Review Timing**: Shows review prompts only when users have 3+ days of diary entries with content within the past 6 months
- **Cooldown Management**: Prevents showing review prompts more than once every 6 months
- **User Preference Respect**: Allows users to decline and never show again
- **OS Native Integration**: Uses the platform's native in-app review system (App Store/Google Play)
- **Non-intrusive**: Silent failure to ensure user experience is never interrupted

## Architecture

### Core Components

#### InAppReviewService
Central service that manages all review prompt logic:
- `shouldShowReviewPrompt()`: Determines eligibility based on user activity and preferences
- `requestReview()`: Triggers the native OS review prompt
- `markAsDeclined()`: Records user preference to not show again
- `recordReviewShown()`: Updates the last shown timestamp

#### InAppReviewDialog
Custom dialog that provides users with options:
- **Rate Now**: Opens native in-app review
- **Not Now**: Dismisses until next eligibility check
- **Don't Ask Again**: Permanently disables review prompts

### Database Integration

Adds `countDaysWithNonEmptyEntries()` method to `DbClient` to efficiently count distinct dates with diary content within a date range.

### Preferences Management

Extends `PrefsClient` with new keys:
- `lastInAppReviewShownAt`: Timestamp of last review prompt
- `hasDeclinedInAppReview`: User preference to disable prompts

### Internationalization

Supports both English and Japanese with proper localization:
- Review dialog title and message
- Action button labels
- Consistent with app's i18n patterns

## Usage

### Setup

The service is automatically configured in `main.dart` and integrated into the home page's diary save functionality.

### Trigger Conditions

Review prompts are shown when ALL conditions are met:
1. User has not declined review prompts
2. At least 6 months have passed since last prompt (or never shown)
3. User has 3+ days with non-empty diary entries in the past 6 months

### Integration Points

- **Home Page**: Checks eligibility after successful diary saves
- **Provider System**: Uses Riverpod for dependency injection
- **Error Handling**: Graceful failure without user disruption

## Technical Details

### Dependencies

- `in_app_review: ^2.0.9` - Platform-specific review prompts
- `riverpod` - State management and dependency injection
- Core packages: `db_client`, `prefs_client`, `i18n`, `theme`, `widgets`

### Configuration

No additional configuration required. The service:
- Automatically respects platform capabilities
- Falls back gracefully on unsupported platforms
- Uses established app patterns for consistency

### Testing

Comprehensive unit tests cover:
- Review eligibility logic
- Preference management
- Database integration
- Error conditions

## Implementation Notes

### Performance Considerations

- Database queries are optimized with proper indexing
- Eligibility checks are performed asynchronously
- No blocking operations in UI thread

### Privacy & UX

- No tracking of actual review content
- Respects user choices permanently
- Non-intrusive timing (post-success, not during active use)
- Silent error handling preserves user experience

### Platform Support

- iOS: Uses `SKStoreReviewController`
- Android: Uses Google Play In-App Review API
- Graceful degradation on unsupported platforms

This implementation follows One Page's architectural patterns and provides a respectful, effective way to gather user feedback through app store reviews.
