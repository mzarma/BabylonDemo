## General 
- UI and UX are very important aspects of an application, however on this demo project, focus was placed on the architecture that provides expandability and enables someone to easily add new features
- The app downloads all data simultaneously on startup instead of downloading the users, posts and comments separately, which enables the user to see the details of a post even if he doesn't have internet connection and never visited the detail view, thus having a better user experience

## Architecture
- The app's architecture can be shown in the attached diagram (architecture.pdf)
- As shown in the diagram, modularity and a clear separation of concerns are being achieved
- The app consists of six separate modules: Main, Coordination, Presentation, UI, Persistence and Networking. Independence is achieved by applying the SOLID principles and clean architecure principles
- Every module could be reused in other apps as it is independent of the other modules. Furthermore, by applying the dependency inversion principle with use of protocols, every concrete implementation of a protocol could be easily replaced with another, without this affecting other parts of the application
- The main module is responsible for the creation of every object with use of factories

## Testing
- In spite of the fact that this project wasn't written with TDD, clear separation of concerns and proper use of the SOLID principles enabled high testability of the code, thus resulting in a code coverage of 93.84%
