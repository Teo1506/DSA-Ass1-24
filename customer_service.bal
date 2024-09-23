import ballerina/grpc;
import ballerina/uuid;


type Customer record{|
readonly string user_id;
string user_name;
string password;
string role;
|};

type CustomerProduct record {|
readonly string product_id;
string product_name;
float product_price;
int stock_quantity;
int stock_keeping_unit; 
|};


type Cart record {|
string cart_id;
string user_id;
string product_id;
int quantity;    
|};



table<Customer> customerTable = table[];

table<CustomerProduct>  customerProductTable = table[];

table<Cart> cartTable = table[];

type ListProductsResponse record {
    CustomerProduct product;
};
type ProductDetailsResponse record {
    CustomerProduct product;
};
type CancelOrderResponse record {
    string order_id;
    string status;
};


# Description.
@grpc:Descriptor {value: SHOPPING_DESC}

service "Customer" on grpcListener {
        remote function AddCustomer(AddCustomerRequest value) returns AddCustomerResponse|error {
            Customer newCustomer = {user_id:value.user_id ,user_name:value.user_name,password:value.password,role:value.role};

        customerTable.add(newCustomer);
        
        AddCustomerResponse response = {user_id: value.user_id,role: value.role };
        return response;
    }

    remote function AuthenticateUser(AuthenticateCustomerRequest value) returns AuthenticateCustomerResponse|error {
        boolean isAuthenticated = false;
        
        foreach Customer customer in customerTable {
            if customer.user_name == value.user_name && customer.password == value.password{
                isAuthenticated = true;
                break;
            }
        }

        string message = isAuthenticated? "Authentication Successful" : "Authentication Failed";

        AuthenticateCustomerResponse response = {message : message};
        return response; 
    }

    remote function ListAvailableProducts(Empty value) returns ListProductsResponse|error {
        ListProductsResponse response = {product_id: "", product_name: "", product_price: 0.0, stock_quantity: 0, stock_keeping_unit: 0,product: {product_id: "", product_name: "", product_price: 0.0, stock_quantity: 0, stock_keeping_unit: 0}};

        foreach CustomerProduct product in customerProductTable{
            response={product:product};
            break;
        }
            return response;
    }


    remote function SearchProduct(SearchProductRequest value) returns ProductDetailsResponse|error {
        ProductDetailsResponse response;
        string searchQuery = value.query.toLowerAscii();

        foreach CustomerProduct product in customerProductTable{
            if product.product_name.toLowerAscii().includes(searchQuery){
                response={product:product};
                break;
            }
        }
   
        return response;
        
    }

    remote function AddToCart(AddToCartRequest value) returns AddToCartResponse|error {
        string cart_id = generateCartId();

        Cart newCartItem = {cart_id:cart_id,user_id: value.user_id,product_id: value.product_id,quantity: value.quantity};

        cartTable.add(newCartItem);


        AddToCartResponse response = {cart_id: cart_id};
        return response;
     }
    

    remote function PlaceOrder(PlaceOrderRequest value) returns PlaceOrderResponse|error {
        string order_id = generateOrderId();
     
        PlaceOrderResponse response = {order_id: order_id};
        return response;

    }

    remote function CancelOrder(CancelOrderRequest value) return CancelOrderResponse|error{
        CancelOrderResponse response = {order_id: value.order_id, status: "Cancelled"};

        return response;
    } 

}

    
function generateCartId() returns string {
    return "cart" + uuid:uuid();
}
function generateOrderId() returns string {
    return "order" + uuid:uuid();
}

        


