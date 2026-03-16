# **This project is an e-commerce mobile application composed of two separate repositories:**
1. Backend Repository: Spring Boot REST API
2. Frontend Repository: Flutter mobile application

## **The system includes:**
1.    User registration and login
2.    OTP email verification
3.    JWT authentication
4.    Products and categories
5.    Cart and wishlist
6.    Orders and checkout
7.    Profile management with image upload
8.    Email notifications 

## **Environment Setup Required:**
* Before running the project, install the following tools.
* Backend Requirements:
    1. Java JDK 17 or later
    2. Maven
    3. MySQL Server
    4. MySQL Workbench
    5. IntelliJ IDEA or VS Code

* Frontend Requirements:
    1. Flutter SDK
    2. Dart SDK
    3. Android Studio
    4. Android Emulator or physical Android device
    5. Flutter and Dart plugins installed in Android Studio

## **Verify Installed Tools:**
* Check Java:
  1. java -version
  2. javac -version
* Check Maven:
  1. mvn -version
* Check Flutter:
  1. flutter --version 
  2. flutter doctor
Make sure all Flutter doctor issues are resolved before running the app.

## **Backend Setup (Spring Boot):**

### **Step 1: Clone Backend Repository**
* git clone https://github.com/dana25578/flutter-training-backend.git
* cd flutter-training-backend

### **Step 2: Create Database**
* Open MySQL and run: CREATE DATABASE app_db;

### **Step 3: Configure application.properties**
*    Open:src/main/resources/application.properties
* Use:
        server.port=8081
        spring.datasource.url=jdbc:mysql://localhost:3306/app_db
        spring.datasource.username=root
        spring.datasource.password=YOUR_DATABASE_PASSWORD
        spring.jpa.hibernate.ddl-auto=update
        spring.jpa.show-sql=true
        spring.mail.host=smtp.gmail.com
        spring.mail.port=587
        spring.mail.username=YOUR_GMAIL
        spring.mail.password=YOUR_GMAIL_APP_PASSWORD
        spring.mail.properties.mail.smtp.auth=true
        spring.mail.properties.mail.smtp.starttls.enable=true
        spring.mail.properties.mail.smtp.starttls.required=true
        store.owner.email=OWNER_EMAIL
        store.mail.from=YOUR_GMAIL
        app.publicBaseUrl=http://localhost:8081
        app.jwt.secret=YOUR_SECRET_KEY
        app.jwt.expMinutes=1440
        spring.servlet.multipart.enabled=true
        spring.servlet.multipart.max-file-size=10MB
        spring.servlet.multipart.max-request-size=10MB
* Replace:
  1. YOUR_DATABASE_PASSWORD
  2. YOUR_GMAIL 
  3. YOUR_GMAIL_APP_PASSWORD
  4. OWNER_EMAIL
  5. YOUR_SECRET_KEY

### **Step 4: Build Backend**
* mvn clean install

### **Step 5: Run Backend**
* mvn spring-boot:run
Or run the main class:
* AppApplication.java

### **Step 6: Verify Backend Running**
* Backend runs on:http://localhost:8081
* Test:http://localhost:8081/api/products

## **Frontend Setup (Flutter Mobile Application)**

### **Step 1: Clone Frontend Repository**
* git clone https://github.com/dana25578/flutter-training.git
* cd flutter-training

### **Step 2: Install Dependencies**
* flutter pub get

### **Step 3: Open in Android Studio**
* Open project folder in Android Studio

### **Step 4: Start Emulator**
* Launch Android emulator

### **Step 5: Confirm Backend URL**
* The frontend uses:http://10.0.2.2:8081

This is correct for Android emulator because:
* 10.0.2.2 points to localhost of your computer
* backend must already be running
If using a physical device, replace with your computer IP:http://YOUR_LOCAL_IP:8081

### **Step 6: Run Flutter App**
* flutter run
* Or click Run in Android Studio.

## **Exact Steps to Start the Full System From Scratch:**

Follow this order exactly:

### **Step 1:**

* Start MySQL server

### **Step 2:**
* Create database: CREATE DATABASE app_db;

### **Step 3:**
* Run backend:mvn spring-boot:run
* Wait until backend starts on port 8081.

### **Step 4:**
* Start Android emulator.

### **Step 5:**
* Run frontend: flutter run

### **Step 6:**

Test application flow:
* Open home page
* Register new account
* Verify OTP
* Login
* Browse products
* Add to cart
* Add to wishlist
* Update profile
* Checkout
* View orders

## **API Summary:**
**1. Authentication:**
* POST /api/auth/register
* POST /api/auth/login
* POST /api/auth/verify-otp
* POST /api/auth/resend-otp

**2. Categories:**
* GET /api/categories

**3. Products:**
* GET /api/products
* GET /api/products/by-category/{categoryId}

**4. Cart:**
* GET /api/cart
* PUT /api/cart
* DELETE /api/cart/clear

**5. Wishlist:**
* GET /api/wishlist
* PUT /api/wishlist/toggle
* DELETE /api/wishlist/clear

**6. Orders:**
* POST /api/orders
* GET /api/orders/by-user/{userId}

**7. Users:**
* GET /api/users/{id}
* PUT /api/users/{id}

**8. Profile Image:**
* POST /api/profile/upload-image

## **Important Notes**
* Database Tables:
 Tables are created automatically because backend uses: spring.jpa.hibernate.ddl-auto=update

* Email Sending: OTP and order emails require correct Gmail SMTP settings.

* Profile Images: Profile images are stored in: uploads/profile/

* Backend Must Run First: Frontend depends on backend APIs, so backend must always start before frontend