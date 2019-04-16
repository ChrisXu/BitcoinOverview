# N26-BitcoinOverview

## Architecture

This project follows the MVP pattern which holds a nice balance between trade-offs in terms of testability, readability, and speed for development.

- *Model* - The pure logic components
- *View* - The instances for logic relating to the UI and user interaction.
- *Presenter* - The instances for logic relating to the certain business case.

*protocol-oriented programming* as a key concept in Swift, it plays an important role in the project. `Presentable` is the contract between view and presenter. In other words, the view knows nothing about the actual classes of the presenter (and models).  As long as it gets a corresponding instance of  `Presentable`, it will just work.

By this separation, developers can mock the objects easily and decouple the dependencies as less as possible.

Same goes to the `Backend` as well, the `Backend` is just a protocol which will perform the network requests, and we can create mocked backend for any testing purpose without interfering the real network layer.

That being said, every architecture comes with a price. It requires writing a bit more codes and abstract contracts.

## Modeling data

I'm personally a fan of using `Codable`, but unfortunately the JSON response from *CoinDesk* is not optimal for mobile. This means we will need to write redundant codes for parsing the data with `Decodable`. If we decide to switch the endpoint, all this hard work will vanish. Hence for the minimal viable product, I've just created the custom `Parser` to decode the JSON into the data model.

## Networking

The networking is handled by a simple protocol, `Backend`

```swift
public protocol Backend {

    var urlSession: URLSession { get }

    var baseURL: String { get }

    @discardableResult
    func perform(_ request: Request, completion: ((Result<Data, BackendError>) -> Void)?) -> URLSessionTask?
}
```

Its responsibility is to perform the requests and to handle generic tasks. Once the `URLSessionTask` is completed, it will return a `Result` type which follows Swift 5 standard.

TODO:
*  Handle status code 204 which does not respond with any data

## 3rd party frameworks

There is no 3rd party framework, although I do want to integrate `SwiftLint` for a better code base.

## Tests

### UnitTest

There are examples of *service* and *presenter*  by using `MockBackend`.

One thing to note is that since the `ViewController` just needs a presenter which conforms to `Presentable` we can also have tests for it like verifying the localization strings, button actions, the integrity of the listView, etc

This is essential in my past experience because UITesting is expensive in terms of time and resource.

### UITests

It's a pity that I don't have time left for implementing any UITests.
The setup for UITests is also included in the project. The application will detect whether if it's in UITesting mode or not.

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let backend: Backend = isUITesting ? MockBackend() : RestfulBackend()

    ...
}
```

Most of the UI elements has its own `accessibilityIdentifier`, so it will be relatively easy to set up the test.

## Design

| Mockup         | Screen        |           
| :------------- |:-------------:|
|![Mockup-List](https://github.com/ChrisXu/N26-BitcoinOverview/blob/master/screenshots/mockup-pricelist.png)|![Screen-List](https://github.com/ChrisXu/N26-BitcoinOverview/blob/master/screenshots/screenshot-pricelist.png)|
|![Mockup-Detail](https://github.com/ChrisXu/N26-BitcoinOverview/blob/master/screenshots/mockup-pricedetail.png)|![Screen-Detail](https://github.com/ChrisXu/N26-BitcoinOverview/blob/master/screenshots/screenshot-pricedetail.png)|
