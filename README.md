# ShopSphere 🛍️

A feature-rich, visually stunning e-commerce mobile application built with Flutter. This project demonstrates advanced UI/UX concepts, robust state management, and live API integration, transforming a simple data source into a complete, memorable shopping experience.

![ShopSphere Demo GIF](https://github.com/ZubairAlltaf/shopsphere/blob/main/assets/shopsphere-demo.gif?raw=true)

---

## ✨ About The Project

ShopSphere was developed as a capstone project during my training at **Think Code**. The primary goal was to move beyond basic tutorials and apply advanced Flutter concepts to build a production-quality application.

The project's philosophy is that a great user interface is not just about functionality; it's about creating an immersive and confident experience for the user. Every screen has been meticulously designed and custom-built to be unique, professional, and highly competitive in today's app market.

---

## 🚀 Key Features

-   **"Hell-Level" Themed Login Screen:** A fully custom, animated login experience with a `CustomPainter` for a "pulsating lava" background, staggered animations, and themed widgets that create an unforgettable first impression.
-   **Dynamic & Personalized Home Screen:** Greets users by name and features a unique wavy header design, also built with a `CustomPainter`.
-   **Interactive Shopping Cart:** A clean, modern UI with intuitive quantity controls (`+`/`-`) and easy item removal.
-   **Professional Checkout Flow:** A multi-step, beautifully sectioned interface for shipping, payment, and order summary, complete with subtle animations and interactive elements.
-   **Detailed Order History:** Custom-designed, expandable cards for each order, showcasing item details with product images and a clear order status.
-   **Robust State Management:** Centralized app state managed efficiently using the `Provider` package for authentication, cart, and orders.
-   **Custom Reusable Widgets:** Features like a custom `SnackBar` ensure a consistent and branded feel across the entire application.
-   **Live API Integration:** Fetches product data from the [Fake Store API](https://fakestoreapi.com/) and gracefully handles loading and error states.

---

## 🛠️ Built With

This project was built using the following technologies and packages:

* [**Flutter**](https://flutter.dev/) - The UI toolkit for building natively compiled applications.
* [**Dart**](https://dart.dev/) - The programming language for Flutter.
* [**Provider**](https://pub.dev/packages/provider) - For state management.
* [**google_fonts**](https://pub.dev/packages/google_fonts) - For custom, high-quality typography.
* [**intl**](https://pub.dev/packages/intl) - For professional date formatting.
* [**http**](https://pub.dev/packages/http) - For making API requests.

---


<table style="width:100%; border: none;">
  
  <tr>
    <td align="center"><b>High-Level Login</b></td>
    <td align="center"><b>Personalized Home</b></td>
    <td align="center"><b>Interactive Cart</b></td>
  </tr>
  <tr>
    <td align="center"><b>Professional Checkout</b></td>
    <td align="center"><b>Order History</b></td>
    <td align="center"><b>Empty States</b></td>
  </tr>
</table>

---

## 🏁 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

Make sure you have the Flutter SDK installed on your machine.
* [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)

### Installation

1.  Clone the repo
    ```sh
    git clone [https://github.com/ZubairAlltaf/shopsphere.git](https://github.com/ZubairAlltaf/shopsphere.git)
    ```
2.  Navigate to the project directory
    ```sh
    cd shopsphere
    ```
3.  Install dependencies
    ```sh
    flutter pub get
    ```
4.  Run the app
    ```sh
    flutter run
    ```

---

## 📂 Project Structure

The project follows a clean, feature-first directory structure to keep the code organized and scalable.

lib
├── models/         # Data models (Product, CartItem, Order, etc.)
├── providers/      # State management logic (AuthProvider, CartProvider, etc.)
├── screens/        # UI for each screen (Login, Home, Cart, etc.)
├── widgets/        # Reusable custom widgets (CustomSnackBar, Headers, etc.)
└── main.dart       # App entry point, theme, and routes


---

## 👤 Contact

Zubair Altaf - [@ZubairAlltaf](https://github.com/ZubairAlltaf)

LinkedIn Profile: [https://www.linkedin.com/in/muhammad-zubair-215172376/](https://www.linkedin.com/in/muhammad-zubair-215172376/)

Project Link: [https://github.com/ZubairAlltaf/shopsphere](https://github.com/ZubairAlltaf/shopsphere)

---

## 🙏 Acknowledgments

* A special thank you to **Think Code** for the invaluable training and mentorship provided throughout this project.
* [Fake Store API](https://fakestoreapi.com/) for providing the product data.
* The Flutter community for its incredible documentation and resources.
