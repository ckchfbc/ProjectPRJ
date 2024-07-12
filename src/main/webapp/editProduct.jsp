<%@page import="DAOs.CategoryDAO"%>
<%@page import="Models.Product"%>
<%@page import="DAOs.ProductDAO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="DAOs.ProductItemDAO"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Product</title>
        <link rel="stylesheet" href="styles.css">

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f4f4;
            }

            .container {
                width: 100%;
                margin: 20px auto;
                overflow: hidden;
            }

            .content-container {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            .form-container,
            .list-container {
                background: #fff;
                width: 50%;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            .form-container h3,
            .list-container h3 {
                margin-bottom: 20px;
                font-size: 24px;
                color: #333;
            }

            .form-container label {
                display: block;
                font-weight: bold;
                color: #555;
                margin-bottom: 5px;
            }

            .form-container input,
            .form-container textarea,
            .form-container select {
                width: 100%;
                padding: 10px;
                margin-bottom: 20px;
                border: 1px solid #ccc;
                border-radius: 4px;
                font-size: 16px;
            }

            .form-container button {
                background: #007bff;
                color: #fff;
                border: none;
                padding: 10px 20px;
                cursor: pointer;
                font-size: 16px;
                border-radius: 4px;
                transition: background 0.3s ease;
            }

            .form-container button:hover {
                background: #0056b3;
            }

            .flex {
                display: flex;
                justify-content: space-between;
                gap: 10px;
            }

            .img-container {
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }

            .img-container img {
                max-width: 100%;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            table {
                width: 100%;
                border-collapse: collapse;
                table-layout: fixed;
            }

            table th,
            table td {
                padding: 10px;
                border: 1px solid #ddd;
                word-wrap: break-word;
            }

            table th {
                background-color: #f2f2f2;
            }

            .actions button {
                margin-right: 5px;
            }

            @media (min-width: 768px) {
                .content-container {
                    flex-direction: row;
                }

                .form-container,
                .list-container {
                    flex: 1;
                }

                .list-container {
                    margin-left: 20px;
                }
            }
            .flex-container {
                display: flex;
                gap: 10px; /* Adjust the gap as needed */
            }
            .flex-container div {
                margin: 0;
                padding: 0;
            }
            label {
                display: block;
                margin-bottom: 5px;
            }
        </style>
    </head>

    <body>
        <%
            String id = (String) request.getAttribute("editID");
            ProductDAO pDao = new ProductDAO();
            Product product = pDao.getProduct(id);
        %>
        <div class="container">
            <div class="content-container">
                <div class="form-container">
                    <div class="img-container">
                        <img style="width: 500px; height: 500px" src="<%= product.getPro_img()%>"
                             alt="Product Image">
                    </div>
                    <div class="form-content">
                        <h3>Edit Product</h3>
                        <form method="post" action="/ProductController">
                            <label for="product-ID">Product ID</label>
                            <input id="product-ID" type="text"
                                   placeholder="Product ID" name="proID"
                                   value="<%= product.getPro_id()%>" readonly>

                            <label for="product-name">Product Name</label>
                            <input id="product-name" type="text"
                                   placeholder="Product Name" name="proName"
                                   value="<%= product.getPro_name()%>">

                            <label for="product-description">Product
                                Description</label>
                            <input id="product-description"
                                   placeholder="Product Description"
                                   name="proDes"
                                   value="<%= product.getPro_des()%>"
                                   />

                            <div class="flex-container">

                                <div>
                                    <label for="product-category">Product
                                        Category</label>

                                    <select name="cat" disabled="">
                                        <%
                                            CategoryDAO cDAO = new CategoryDAO();
                                            String parentName = cDAO.getCatName(product.getCategory().getParent()).getCat_name();
                                            int parentId = product.getCategory().getParent();
                                        %>
                                        <option value="<%= parentId%>" selected><%= parentName%></option>
                                    </select>
                                </div>
                                <div>
                                    <label for="product-subcategory">Product
                                        Subcategory</label>
                                    <select
                                        name="proSubCat">
                                        <%
                                            ResultSet rs = cDAO.getAllSubCat(String.valueOf(product.getCategory().getParent()));
                                            while (rs.next()) {
                                                String catName = rs.getString("name");
                                                String selected = "";
                                                if (product.getCategory().getCat_name().equals(catName)) {
                                                    selected = "selected";
                                                }
                                        %>
                                        <option value="<%= rs.getString("id")%>" <%= selected%>><%= catName%></option>
                                        <%}%>
                                    </select>
                                </div>
                            </div>
                            <a href="/Admin_profile" class="bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-1 px-2 rounded">Back</a>
                            <button type="submit" name="btnUpdate">Update Product</button>
                        </form>
                    </div>
                </div>
                <%
                    if (!parentName.equals("Accessories")){
                %>
                <div class="list-container">
                    <h3>Manage Products</h3>
                    <table>
                        <thead>
                            <tr>
                                <th>Product Item ID</th>
                                <th>Option</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                    ProductItemDAO 
                                
                                pidao = new ProductItemDAO();
                                rs = pidao.getProductItemFromProduct(String.valueOf(product.getPro_id()));

                                while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getString("proItemID")%></td>

                                <td>
                                    <%
                                        ResultSet rs2 = pidao.getProductVariance(rs.getString("proItemID"));
                                        while (rs2.next()) {
                                    %>
                                    <%= rs2.getString("variane_name")%> : <%= rs2.getString("variance_value")%> <br/><br/>
                                    <%
                                        }
                                    %>
                                </td>
                                <td><%= rs.getString("quantity")%></td>
                                <td><%= rs.getString("price")%></td>
                                <td>

                                    <a href="/ProductController/EditProductItem/<%= rs.getString("proItemID")%>" class="bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-1 px-2 rounded">Edit</a>
                                    <form
                                        action="ProductController/DeleteProductItem/<%= rs.getString("proItemID")%>"
                                        method="post">
                                        <button type="submit"
                                                class="bg-red-500 hover:bg-red-700 text-white font-bold py-1 px-2 rounded">Delete</button>
                                    </form>
                                </td>
                            </tr>
                            <% }%>
                        </tbody>
                    </table>
                </div>
                        <%}%>

                <script>
                    var productId = '';

                    function setProductId(id) {
                        productId = id;
                        console.log('Product ID:', productId); // For debugging purposes
                        // You can use productId as needed here
                    }
                </script>

            </div>
        </div>
        <script src="script.js"></script>
        <script>
                    document.getElementById('product-category').addEventListener('change', function () {
                        var category = this.value;
                        var subcategorySelect = document.getElementById('product-subcategory');
                        subcategorySelect.disabled = false;
                        var options = subcategorySelect.options;
                        for (var i = 0; i < options.length; i++) {
                            if (options[i].getAttribute('data-option') == category) {
                                options[i].style.display = 'block';
                            } else {
                                options[i].style.display = 'none';
                            }
                        }
                    });

                    // Pre-select category and subcategory if values are known
                    document.getElementById('product-category').value = "Pre-filled Category ID";
                    document.getElementById('product-category').dispatchEvent(new Event('change'));
                    document.getElementById('product-subcategory').value = "Pre-filled Subcategory ID";

                    document.addEventListener('DOMContentLoaded', function () {
                        var editButtons = document.querySelectorAll('.edit-button');
                        editButtons.forEach(function (button) {
                            button.addEventListener('click', function () {
                                document.getElementById('product-ID').value = this.dataset.id;
                                document.getElementById('product-name').value = this.dataset.name;
                                document.getElementById('product-description').value = this.dataset.description;
                                document.getElementById('product-quantity').value = this.dataset.quantity;
                                document.getElementById('product-price').value = this.dataset.price;
                                document.getElementById('product-category').value = this.dataset.category;
                                document.getElementById('product-category').dispatchEvent(new Event('change'));
                                document.getElementById('product-subcategory').value = this.dataset.subcategory;
                            });
                        });
                    });
        </script>
    </body>

</html>
