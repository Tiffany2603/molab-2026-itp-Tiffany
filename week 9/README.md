# Peer Help Lobby

Week 09, Part 2, Option 2: customize the class MoLobby with a small multi-user experience.

## Project

The local Xcode project is `Peer Help Lobby/MoLobby/MoLobby.xcodeproj`. Select the `MoLobby` scheme. The source is based directly on the private [classroom repository](https://github.com/molab-itp/98-MoGallery-Private/tree/main/MoLobby), with a local branch named `Tiffany`.

The classroom repository currently disables forks: GitHub rejected the fork request with HTTP 403. The instructor needs to enable forking before the required personal fork and remote `Tiffany` branch can be submitted. The private classroom source is kept separately from the public coursework documentation.

## Run

1. Open `Peer Help Lobby/MoLobby/MoLobby.xcodeproj` in Xcode and let the class Firebase and Google Sign-In packages resolve.
2. Choose an iOS Simulator or an iPhone. For a phone, select your development team in Signing & Capabilities and follow any signing messages for the class project.
3. Run the `MoLobby` scheme. Use the class Sign In Anonymously button for an initial test. If the original Google sign-in flow opens first, cancel it to return to the login screen.
4. For a multi-user test, run a second client, such as another simulator or a phone. Both clients use lobby `tiffany-peer-help` under the class `mo-6/` prefix. Use an internet connection to confirm publishing.

The class project targets iOS 17.6 or later. The existing Firebase and Google login configuration is retained.

## Use

- **Need Help**: enter something you need help with. Category: 🙋.
- **Can Help**: describe what you can help with. Category: 🤝.
- **Share Status**: share a current status or learning update. Category: 💬.

Each button opens the same multiline input form. Post creates a new independent document, so one person can publish several messages without replacing earlier ones. Names remain visible, categories display as emoji, and the newest posts appear first with a date and time. The number beside Posts counts posts, not people online.

Empty or whitespace-only messages are disabled. While publishing, the controls are disabled to avoid repeated taps. The form closes after Firestore confirms the write; an error keeps the message in the form and displays a warning. Cancel closes the form without writing.

Posts are stored in `gstore/mo-6/lobbies/tiffany-peer-help/posts/{postID}`. Each document contains `authorID`, `name`, `profileImg`, `category`, `text`, and `createdAt`. The class user documents remain separate. Earlier messages stored in user captions are left unchanged and are not automatically copied into the new posts list.

## Class Code and Changes

- The class `UserModel.swift` and authentication methods are retained. `LobbyModel.swift` still uses the original user-writing and user-listener code for identities.
- `PostModel.swift` is new. Its dictionary-based initializer follows the class `UserModel` pattern, but represents one message instead of one person.
- `FirestorePaths.swift` adds `lobbyPosts`, following the existing `lobbyUsers` path pattern.
- `LobbyModel.swift` adds `addPost` and `observePostsStart`. They adapt the class `setData` and `addSnapshotListener` patterns. Each submission uses a fresh document ID. Refresh restarts both listeners, and sign-out stops them and clears the displayed data.
- `LobbyView.swift` adapts the class list, `ForEach`, and `AsyncImage` layout for posts. The three buttons share an input sheet, using the class `UserDetailView` multiline `TextField` pattern. Posting state, error text, emoji categories, and timestamps are additions.
- `Settings.swift` and `MoLobbyApp.swift` select the project lobby and open the list by default. `LoginView.swift` changes the introduction and removes the unused location request.

I learned the independent-post design after asking ChatGPT how to keep several messages from the same person. The class MoLobby uses one caption per user; the new post model, collection, and per-submission ID extend that example. More detail is in [Learning Record](Learning_Record.md).

## Verification

The updated iOS device target compiled without code signing. An isolated temporary cloud test confirmed that two posts by the same author remain separate, a second authenticated client can read them, all three categories persist, timestamps support newest-first sorting, and separators, newlines, and emoji remain intact. All three test documents and both temporary accounts were deleted afterward.

The earlier simulator check covered the English controls and emoji layout before the independent-post change. A full two-client UI check of the new feed has not been completed. Fork submission remains blocked by the classroom repository setting.
