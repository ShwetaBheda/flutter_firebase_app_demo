**Flutter Chat Application with Firebase Authentication**


This Flutter project is a chat application using the Bloc pattern and Firebase services. The app allows users to send and receive posts in real-time, leveraging Firestore as the backend for post storage. Authentication is handled through Firebase, allowing users to register and log in securely.

**Features**
- **Real-Time Chat**: Displays posts in a WhatsApp-style chat interface, where users can send posts with their usernames and timestamps. The posts are displayed with the current user’s messages aligned on the right (with a blue background) and other users’ messages on the left.
Firebase Authentication: Users can sign up and log in using Firebase, and their session is maintained across app sessions.

- **Post Management:** Users can add new posts, which are stored in Firestore in real time. The app fetches posts in the reverse order, displaying the latest post first.
- **Post Timestamps:** Each post is accompanied by a timestamp, showing when it was sent.
- **Bloc Architecture:** The app is structured using the Bloc pattern for state management, ensuring a clean separation of concerns between business logic and UI.

**Key Concepts**
- **Post Bloc**: Manages the state of posts using PostEvent, PostState, and the PostBloc. This ensures efficient state handling for loading posts, adding new posts, and handling errors.
- **Authentication Bloc:** Implements Firebase authentication using AuthBloc, AuthEvent, and AuthState. This structure allows smooth login and signup flows and maintains authentication state across app screens.
- **Stream-Based Architecture:** Posts are fetched and updated in real-time using Firestore streams, allowing immediate display of new posts without manual refresh.


**File Structure**
- **blocs/:**
auth_bloc.dart: Manages the authentication state.
post_bloc.dart: Handles post-related state management.

- **events/:**
auth_event.dart: Defines authentication events (e.g., login, signup).
post_event.dart: Defines post-related events (e.g., load posts, add post).

- **states/:**
auth_state.dart: Defines various states of authentication (e.g., authenticated, unauthenticated).
post_state.dart: Manages the state of posts (loading, loaded, error).

- **screens/:**
home_screen.dart: Displays the chat interface.
login_screen.dart: Login interface for the user.
signup_screen.dart: Signup interface for new users.

- **services/:**
post_service.dart: Contains methods for interacting with Firestore to fetch, add, and manage posts.

**How to Run**

1. Clone the repository:
git clone <repository_url>

2. Install dependencies
flutter pub get

3. Set up Firebase:

- Create a Firebase project at Firebase Console.
- Add Android/iOS apps to the Firebase project.
- Download the google-services.json (for Android) or GoogleService-Info.plist (for iOS) and place it in the appropriate directories (android/app/ and ios/Runner/).
- Enable Authentication and Firestore Database in Firebase.

4. flutter run


