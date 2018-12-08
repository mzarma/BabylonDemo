## General Decisions
- I consider UI and UX as very important aspects of an application, however I decided to create a simple UI and focus on the architecture which provides expandability and enables someone to easily add new features
- I decided to download all data simultaneously (using a dispatch group) because a user should be able to see the details of a post even if he does't have internet connection and never visited the detail view, thus having a better user experience

## Architecture

- The app's architecture can be shown in the attached diagram (architecture.pdf)
- As shown in the diagram, modularity and a clear separation of concerns are being achieved
- The app consists of six separate modules: Main, Coordination, Presentation, UI, Persistence and Networking. Independence is achieved by applying the SOLID principles and clean architecure principles
- Code coverage of 93.84% has been achieved
