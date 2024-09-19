import ballerina/grpc;
import ballerina/io;

// Stub for the Customer service
ShoppingCustomerClient = grpc:createClient("http://localhost:9090", config = {});

// Customer client functionality
type AddCustomerRequest record {
    string user_id;
    string user_name;
    string password;
    string role;
};

type AddCustomerResponse record {
    string user_id;
    string role;
};

type AuthenticateCustomerResponse record {
    string message;
};

type AuthenticateCustomerRequest record {
    string user_name;
    string password;
};

type ListProductsResponse record {
    string product_name;
    float product_price;
    string status;
};

type SearchProductRequest record {
    string product_name;
};

type ProductDetailsResponse record {
    string product_name;
    float product_price;
    string status;
    int stock_quantity;
};

type AddToCartRequest record {
    string user_id;
    string stock_keeping_unit;
    string product_id;
};

type AddToCartResponse record {
    string product_id;
    string product_name;
    float product_price;
    string status;
};

type PlaceOrderRequest record {
    string product_id;
    string product_name;
    float product_price;
    string status;
};

type PlaceOrderResponse record {
    string product_id;
    string product_name;
    float product_price;
};

public function main() {
    // Example: Add a customer
    AddCustomerRequest customerRequest = {
        user_id: "C001",
        user_name: "customer123",
        password: "password",
        role: "customer"
    };
    var customerResponse = ShoppingCustomerClient->AddCustomer(customerRequest);
    if customerResponse is AddCustomerResponse {
        io:println("Customer added with ID: ", customerResponse.user_id);
    } else {
        io:println("Failed to add customer: ", customerResponse);
    }

    // Example: Authenticate a customer
    AuthenticateCustomerRequest authRequest = {
        user_name: "customer123",
        password: "password"
    };
    var authResponse = ShoppingCustomerClient->AuthenticateCustomer(authRequest);
    if authResponse is AuthenticateCustomerResponse {
        io:println("Customer authentication message: ", authResponse.message);
    } else {
        io:println("Failed to authenticate customer: ", authResponse);
    }

    // Example: List available products
    var listResponse = ShoppingCustomerClient->ListAvailableProducts({});
    if listResponse is ListProductsResponse {
        io:println("Available product: ", listResponse.product_name);
        io:println("Price: ", listResponse.product_price);
        io:println("Status: ", listResponse.status);
    } else {
        io:println("Failed to list products: ", listResponse);
    }

    // Example: Search for a product
    SearchProductRequest searchRequest = {
        product_name: "Smartphone"
    };
    var searchResponse = ShoppingCustomerClient->SearchProduct(searchRequest);
    if searchResponse is ProductDetailsResponse {
        io:println("Product found: ", searchResponse.product_name);
        io:println("Price: ", searchResponse.product_price);
        io:println("Stock Quantity: ", searchResponse.stock_quantity);
        io:println("Status: ", searchResponse.status);
    } else {
        io:println("Product not found: ", searchResponse);
    }

    // Example: Add a product to cart
    AddToCartRequest cartRequest = {
        user_id: "C001",
        stock_keeping_unit: "123456",
        product_id: "P001"
    };
    var cartResponse = ShoppingCustomerClient->AddToCart(cartRequest);
    if cartResponse is AddToCartResponse {
        io:println("Added to cart: ", cartResponse.product_name);
    } else {
        io:println("Failed to add to cart: ", cartResponse);
    }

    // Example: Place an order
    PlaceOrderRequest orderRequest = {
        product_id: "P001",
        product_name: "Smartphone",
        product_price: 799.99,
        status: "available"
    };
    var orderResponse = ShoppingCustomerClient->PlaceOrder(orderRequest);
    if orderResponse is PlaceOrderResponse {
        io:println("Order placed successfully for: ", orderResponse.product_name);
    } else {
        io:println("Failed to place order: ", orderResponse);
    }
}
