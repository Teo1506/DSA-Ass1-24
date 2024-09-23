import ballerina/grpc;
import ballerina/uuid;


type Admin record {|
 readonly string user_id;
    string user_name ;
    string password ;
    string role ;
|};

type AdminProduct record {|
   readonly string product_id;
   string product_name;
   float product_price;
   int stock_quantity;
   string stock_keeping_unit;
   string status;
|};

table <Admin> key(user_id) adminTable = table[];
table <AdminProduct> key(product_id) productTable = table[];



listener grpc:Listener grpcListener = new (9090);

# Description.
@grpc:Descriptor {value: SHOPPING_DESC}
service "Admin" on grpcListener {

    remote function AddAdmin(AddAdminRequest value) returns AddAdminResponse|error {
        Admin newAdmin = {user_name: value.user_name,password: value.password,role: value.role,user_id: ""};
        adminTable.add(newAdmin);
  
        AddAdminResponse response = {user_id: value.user_id,role: value.role};
        return response;
    }

    remote function AuthenticateUser(AuthenticateAdminRequest value) returns AuthenticateAdminResponse|error {

        boolean isAuthenticated = false;
        foreach Admin admin in adminTable { 
            if admin.user_name == value.user_name && admin.password == value.password{
                isAuthenticated = true;
                break;
            }
            
        }
      
        string message  = isAuthenticated? "Authentication Successful" : "Authentication Failed";
        
        AuthenticateAdminResponse response = {message : message};
        return response;  

    }

    remote function AddProduct(AddProductRequest value) returns ProductIdResponse|error {
        //ADD PRODUCT DETAILS 
        string product_id = generateProductId();
       
        AdminProduct newProduct = {product_name: value.product_name,product_price: value.product_price,stock_quantity: value.stock_quantity, stock_keeping_unit: value.stock_keeping_unit,product_id: "",status: ""};

        ProductIdResponse response = {product_id: product_id};
        return response;        
    }

    remote function UpdateProduct(UpdateProductRequest value) returns Empty|error {

        
       
        Empty response = {message: "The Product is Updated Successfully"};
        return response;        
    }

    remote function RemoveProduct(RemoveProductRequest value) returns UpdatedListResponse {

        AdminProduct? product = productTable.remove({product_id:value.product_id});

        if product is CustomerProduct{
            
            UpdatedListResponse response = {
            product_id : product.product_id,
            product_name : product.product_name,
            product_price : product.product_price, 
            stock_quantity : product.stock_quantity, 
            stock_keeping_unit : product.stock_keeping_unit,
            status : "Removed"
        };
        return response;
        }
    }

    

    function authenticate(string user_name ,string password) returns boolean|error {
        if user_name == "Admin" && password == "adminpassword"{
            return true;
        }else {
            return false;
        }
        
    }
}

//GENERATE PRODUCT IDs
function generateProductId() returns string {
    return "product" + uuid:createType1AsString();
}

