HelpCenterDemoApp

Welcome to the HelpCenterDemoApp, a project that demonstrates how to build a fully functional Help Center feature in an iOS app using Swift and the VIPER architectural pattern. This demo app simulates a chat-based support system with a presenter, model, and view, all communicating seamlessly to deliver a smooth user experience.
Features

    Dynamic Chat UI: The app contains a table view that dynamically displays different types of cells like text messages, images, and button lists.
    WebSocket Integration: Real-time communication is enabled via WebSocket, which allows sending and receiving chat messages.
    Modular and Testable Architecture: Following the VIPER architecture, the project separates concerns into distinct modules, making it highly modular, testable, and maintainable.
    Custom Navigation Bar: A custom navigation bar content view provides a sleek and intuitive UI for navigating the Help Center.

Architecture

The HelpCenterDemoApp follows the VIPER pattern:

    View: Handles UI updates and user interaction.
    Interactor: Manages the business logic and data fetching.
    Presenter: Acts as the middleman between the view and the interactor.
    Entity: Represents the data models.
    Router: Handles navigation and view transitions.

The main communication flow in the app happens between these layers, ensuring that each component has a single responsibility.
Key Components

    HelpCenterViewController:
        Displays the chat content in a table view.
        Interacts with the presenter to fetch data and handle user interactions.
        Updates the UI based on WebSocket connection status and user inputs.

    HelpCenterPresenterProtocol:
        Defines the contract for the presenter, handling data processing and passing information to the view.
        Sends and receives WebSocket messages.

    HelpCenterChatStepTypes:
        Enum that represents different steps in the chat flow.
        Each step has a raw value to map actions within the chat system.
