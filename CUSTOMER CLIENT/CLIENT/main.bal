import ballerina/io;

AdminClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    AddAdminRequest addAdminRequest = {user_id: "admin123", user_name: "Admin", password: "adminpassword", role: "Admin"};
    AddAdminResponse addAdminResponse = check ep->AddAdmin(addAdminRequest);
    io:println(addAdminResponse);

    AuthenticateAdminRequest authenticateUserRequest = {user_name: "ballerina", password: "ballerina"};
    AuthenticateAdminResponse authenticateUserResponse = check ep->AuthenticateUser(authenticateUserRequest);
    io:println(authenticateUserResponse);

    AddProductRequest addProductRequest = {product_name: "ballerina", product_price: 1, stock_quantity: 1, stock_keeping_unit: 1, status: "ballerina"};
    ProductIdResponse addProductResponse = check ep->AddProduct(addProductRequest);
    io:println(addProductResponse);

    UpdateProductRequest updateProductRequest = {product_id: "ballerina", product_name: "ballerina", product_price: 1, stock_quantity: 1, stock_keeping_unit: "ballerina", status: "ballerina"};
    Empty updateProductResponse = check ep->UpdateProduct(updateProductRequest);
    io:println(updateProductResponse);

    RemoveProductRequest removeProductRequest = {product_id: "ballerina", product_name: "ballerina", status: "ballerina"};
    UpdatedListResponse removeProductResponse = check ep->RemoveProduct(removeProductRequest);
    io:println(removeProductResponse);
}
