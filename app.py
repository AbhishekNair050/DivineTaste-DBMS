from flask import Flask, render_template, request, redirect, jsonify
import mysql.connector
from langchain_google_genai import ChatGoogleGenerativeAI

app = Flask(__name__)

# MySQL configuration
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="Divine_Taste",
)
cursor = db.cursor()

import os

os.environ["GOOGLE_API_KEY"] = ""


# Route for the dashboard page
@app.route("/")
def dashboard():
    return render_template("dashboard.html")


def generate_prompt():
    prompt = ""
    tables = [
        ("Supplier", "SupplierID, SupplierName, Ingredients, Quantity"),
        ("Product", "ProductID, Name, Price, Quantity, Category, Description"),
        ("Event", "EventID, EventName, date, Location, Description"),
        ("Orders", "OrderID, Orderdate, TotalAmount"),
        ("Payment", "PaymentID, Mode, Amount, Timestamp, EventID, OrderID"),
        ("Customer", "CustomerID, Fname, Lname, PaymentID, OrderID"),
        ("Delivery", "DeliveryDate, DeliveryMode, DeliveryInstruction, OrderID"),
        ("Staff", "StaffID, ContactDetails, Role, Salary, Fname, Lname"),
        ("Staff_event", "StaffID, EventID"),
        ("Product_Supplier", "ProductID, SupplierID"),
        ("Customer_product", "CustomerID, ProductID"),
        ("Product_order", "ProductID, OrderID"),
        ("Customer_ContactDetails", "ContactDetails, CustomerID"),
        ("OrderDetails", "Quantity, Subtotal, Occasion, Message, OrderID"),
        ("Staff_order", "StaffID, OrderID"),
        ("Supplier_ContactDetails", "ContactDetails, SupplierID"),
    ]

    for table, attributes in tables:
        prompt += f"Table: {table}, Attributes: {attributes}\n"

    return prompt


def simplify_sql_query(query):
    query = query.strip()
    if query.startswith("```sql"):
        query = query[6:]
    if query.endswith("```"):
        query = query[:-3]
    query = query.strip()

    return query


@app.route("/execute_query", methods=["POST"])
def execute_query():
    question = request.get_json()
    question = question["query"]
    data = generate_prompt()
    hardcoded_prompt = "Query should be based on the given schema only and return only the SQL query, dont give any text as output"
    input_text = (
        hardcoded_prompt + "\nContext:" + data + "\nUser question:\n" + question
    )
    llm = ChatGoogleGenerativeAI(model="gemini-pro")
    result = llm.invoke(input_text)
    query = result.content
    query = simplify_sql_query(query)
    query = query.replace("`", " ")
    print(query)
    try:
        cursor.execute(query)
        result = cursor.fetchall()
    except:
        return "Query failed"
    print(result)
    parsed_result = ""
    if len(result) == 0:
        return "No data found"
    else:
        for i in result:
            if i is None:
                return "No data found"
            elif parsed_result == "":
                parsed_result = " ".join(map(str, i))
            else:
                parsed_result = parsed_result + "\n" + " ".join(map(str, i))
    print(parsed_result)
    return parsed_result


# Route for managing products
@app.route("/manage_products")
def manage_products():
    # Fetch products from the database
    cursor.execute("SELECT * FROM Product")
    products = cursor.fetchall()
    print(products)
    return render_template("manage_products.html", products=products)


# Route for adding a product
@app.route("/add_product", methods=["POST"])
def add_product():
    name = request.form["name"]
    price = float(request.form["price"])
    quantity = int(request.form["quantity"])
    category = request.form["category"]
    description = request.form["description"]

    # Insert the new product into the database
    cursor.execute(
        "INSERT INTO Product (Name, Price, Quantity, Category, Description) VALUES (%s, %s, %s, %s, %s)",
        (name, price, quantity, category, description),
    )
    db.commit()

    # Redirect to the manage_products route to refresh the page
    return redirect("/manage_products")


# Route for managing suppliers
@app.route("/manage_suppliers")
def manage_suppliers():
    # Fetch suppliers from the database
    cursor.execute("SELECT * FROM Supplier")
    suppliers = cursor.fetchall()
    return render_template("manage_suppliers.html", suppliers=suppliers)


# Route for adding a supplier
@app.route("/add_supplier", methods=["POST"])
def add_supplier():
    supplier_name = request.form["supplier_name"]
    ingredients = request.form["ingredients"]
    quantity = int(request.form["quantity"])

    # Insert the new supplier into the database
    cursor.execute(
        "INSERT INTO Supplier (SupplierName, Ingredients, Quantity) VALUES (%s, %s, %s)",
        (supplier_name, ingredients, quantity),
    )
    db.commit()

    # Redirect to the manage_suppliers route to refresh the page
    return redirect("/manage_suppliers")


# Route for editing a supplier
@app.route("/edit_supplier", methods=["GET", "POST"])
def edit_supplier():
    if request.method == "GET":
        # Retrieve the supplier ID from the query parameters
        supplier_id = request.args.get("supplier_id")

        # Fetch the supplier details from the database
        cursor.execute("SELECT * FROM Supplier WHERE SupplierID = %s", (supplier_id,))
        supplier = cursor.fetchone()

        return render_template("edit_supplier.html", supplier=supplier)
    elif request.method == "POST":
        # Retrieve updated supplier details from the form
        supplier_id = request.form["supplier_id"]
        supplier_name = request.form["supplier_name"]
        ingredients = request.form["ingredients"]
        quantity = int(request.form["quantity"])

        # Update the supplier in the database
        cursor.execute(
            "UPDATE Supplier SET SupplierName = %s, Ingredients = %s, Quantity = %s WHERE SupplierID = %s",
            (supplier_name, ingredients, quantity, supplier_id),
        )
        db.commit()

        return redirect("/manage_suppliers")


# Route for deleting a supplier
@app.route("/delete_supplier", methods=["GET"])
def delete_supplier():
    # Retrieve the supplier ID from the query parameters
    supplier_id = request.args.get("supplier_id")

    # Delete the supplier from the database
    cursor.execute("DELETE FROM Supplier WHERE SupplierID = %s", (supplier_id,))
    db.commit()

    return redirect("/manage_suppliers")


@app.route("/manage_orders")
def manage_orders():
    # Fetch all orders and their details from the database
    cursor.execute("SELECT * FROM Orders")
    orders = cursor.fetchall()
    orders_with_details = []
    for order in orders:
        cursor.execute("SELECT * FROM OrderDetails WHERE OrderID = %s", (order[0],))
        order_details = cursor.fetchall()
        orders_with_details.append((order, order_details))

    return render_template(
        "manage_orders.html", orders_with_details=orders_with_details
    )


@app.route("/update_status", methods=["POST"])
def update_status():
    data = request.json
    order_id = data["orderId"]

    # Update the order status to "Done" in the database
    cursor.execute(
        "UPDATE OrderDetails SET stats = 'Done' WHERE OrderID = %s", (order_id,)
    )
    db.commit()

    return jsonify({"message": "Order status updated successfully"}), 200


@app.route("/inventory_management")
def inventory_management():
    # Fetch all products from the database
    cursor.execute("SELECT * FROM Product")
    products = cursor.fetchall()

    return render_template("inventory_management.html", products=products)


# Route for adding a new product
@app.route("/add_inventory", methods=["POST"])
def add_inv():
    product_name = request.form["productName"]
    price = float(request.form["productPrice"])
    quantity = int(request.form["productQuantity"])
    category = request.form["productCategory"]
    description = request.form["productDescription"]

    # Insert new product into the database
    cursor.execute(
        "INSERT INTO Product (Name, Price, Quantity, Category, Description) VALUES (%s, %s, %s, %s, %s)",
        (product_name, price, quantity, category, description),
    )
    db.commit()

    return redirect("/inventory_management")


# Route for editing an existing product
@app.route("/edit_inventory", methods=["POST", "GET"])
def edit_inv():
    if request.method == "GET":
        # Retrieve the product ID from the query parameters
        product_id = request.args.get("product_id")

        # Fetch the product details from the database
        cursor.execute("SELECT * FROM Product WHERE ProductID = %s", (product_id,))
        product = cursor.fetchone()

        return render_template("edit_inventory.html", product=product)
    if request.method == "POST":
        # Retrieve updated product details from the form
        product_id = request.form["product_id"]
        product_name = request.form["product_name"]
        price = float(request.form["price"])
        quantity = int(request.form["quantity"])
        category = request.form["category"]
        description = request.form["description"]

        # Update the product in the database
        cursor.execute(
            "UPDATE Product SET Name = %s, Price = %s, Quantity = %s, Category = %s, Description = %s WHERE ProductID = %s",
            (product_name, price, quantity, category, description, product_id),
        )
        db.commit()

        return redirect("/inventory_management")


# Route for deleting a product
# Route for deleting inventory
@app.route("/delete_inventory", methods=["GET", "POST"])
def delete_inventory():
    if request.method == "GET":
        # Retrieve the product ID from the query parameters
        product_id = request.args.get("product_id")

        # Delete the product from the database
        cursor.execute("DELETE FROM Product WHERE ProductID = %s", (product_id,))
        db.commit()

        # Redirect to the manage_inventory route to refresh the page
        return redirect("/inventory_management")

    # Handle POST request (if needed)
    elif request.method == "POST":
        # Perform additional actions for POST requests, if necessary
        pass


# Route for updating stock level
# Route for updating stock
@app.route("/update_stock", methods=["POST"])
def update_stock():
    if request.method == "POST":
        # Retrieve product ID and update details from the form
        product_id = request.form["updateProductID"]
        update_amount = int(request.form["stockUpdateAmount"])
        update_type = request.form["stockUpdateType"]

        # Fetch the current stock quantity of the product from the database
        cursor.execute(
            "SELECT Quantity FROM Product WHERE ProductID = %s", (product_id,)
        )
        current_quantity = cursor.fetchone()[0]

        # Calculate the new stock quantity based on the update type
        new_quantity = current_quantity
        if update_type == "increase":
            new_quantity += update_amount
        elif update_type == "decrease":
            new_quantity -= update_amount

        # Ensure the new quantity is not negative
        if new_quantity < 0:
            return redirect("/inventory_management")

        # Update the stock quantity in the database
        cursor.execute(
            "UPDATE Product SET Quantity = %s WHERE ProductID = %s",
            (new_quantity, product_id),
        )
        db.commit()

        return redirect("/inventory_management")


def get_total_revenue(start_date, end_date):
    # Fetch total revenue from the database
    cursor.execute(
        "SELECT SUM(SubTotal) FROM Orders natural inner join OrderDetails WHERE OrderDate BETWEEN %s AND %s",
        (start_date, end_date),
    )
    total_revenue = cursor.fetchone()[0]
    return total_revenue


@app.route("/sales_and_revenue_analysis", methods=["GET"])
def sales_and_revenue_analysis():
    return render_template("sales_and_revenue_analysis.html")


@app.route("/total_revenue", methods=["POST"])
def total_revenue():
    if request.method == "POST":
        data = request.get_json()
        start_date = data["startDate"]
        end_date = data["endDate"]
        # Fetch total revenue from database
        total_revenue = get_total_revenue(start_date, end_date)
        return jsonify(total_revenue)


@app.route("/customer_management")
def customer_management():
    # Fetch customers from the database
    cursor.execute("SELECT * FROM Customer")
    customers = cursor.fetchall()
    return render_template("customer_management.html", customers=customers)


# Route for adding a new customer
@app.route("/add_customer", methods=["POST"])
def add_customer():
    fname = request.form["fname"]
    lname = request.form["lname"]
    payment_id = int(request.form["payment_id"])
    order_id = int(request.form["order_id"])

    # Insert new customer into the database
    cursor.execute(
        "INSERT INTO Customer (Fname, Lname, PaymentID, OrderID) VALUES (%s, %s, %s, %s)",
        (fname, lname, payment_id, order_id),
    )
    db.commit()

    return redirect("/customer_management")


# Route for editing an existing customer
@app.route("/edit_customer", methods=["GET", "POST"])
def edit_customer():
    if request.method == "GET":
        # Retrieve the customer ID from the query parameters
        customer_id = request.args.get("customer_id")

        # Fetch the customer details from the database
        cursor.execute("SELECT * FROM Customer WHERE CustomerID = %s", (customer_id,))
        customer = cursor.fetchone()

        return render_template("edit_customer.html", customer=customer)
    elif request.method == "POST":
        # Retrieve updated customer details from the form
        customer_id = request.form["customer_id"]
        fname = request.form["fname"]
        lname = request.form["lname"]
        payment_id = int(request.form["payment_id"])
        order_id = int(request.form["order_id"])

        # Update the customer in the database
        cursor.execute(
            "UPDATE Customer SET Fname = %s, Lname = %s, PaymentID = %s, OrderID = %s WHERE CustomerID = %s",
            (fname, lname, payment_id, order_id, customer_id),
        )
        db.commit()

        return redirect("/customer_management")


# Route for deleting a customer
@app.route("/delete_customer", methods=["GET"])
def delete_customer():
    # Retrieve the customer ID from the query parameters
    customer_id = request.args.get("customer_id")

    # Delete the customer from the database
    cursor.execute("DELETE FROM Customer WHERE CustomerID = %s", (customer_id,))
    db.commit()

    return redirect("/customer_management")


# Route for managing staff
@app.route("/staff_management")
def staff_management():
    # Fetch staff members from the database
    cursor.execute("SELECT * FROM Staff")
    staff_members = cursor.fetchall()
    return render_template("staff_management.html", staffs=staff_members)


# Route for adding a staff member
@app.route("/add_staff", methods=["POST"])
def add_staff():
    fname = request.form["fname"]
    lname = request.form["lname"]
    role = request.form["role"]
    salary = float(request.form["salary"])
    contact_details = request.form["ContactDetails"]

    # Insert the new staff member into the database
    cursor.execute(
        "INSERT INTO Staff (Fname, Lname, Role, Salary, ContactDetails) VALUES (%s, %s, %s, %s, %s)",
        (fname, lname, role, salary, contact_details),
    )
    db.commit()

    # Redirect to the staff_management route to refresh the page
    return redirect("/staff_management")


# Route for editing a staff member
@app.route("/edit_staff", methods=["GET", "POST"])
def edit_staff():
    if request.method == "GET":
        # Retrieve the staff member ID from the query parameters
        staff_id = request.args.get("staff_id")

        # Fetch the staff member details from the database
        cursor.execute("SELECT * FROM Staff WHERE StaffID = %s", (staff_id,))
        staff = cursor.fetchone()

        return render_template("edit_staff.html", staff=staff)
    elif request.method == "POST":
        staff_id = int(request.form["staff_id"])
        fname = request.form["fname"]
        lname = request.form["lname"]
        role = request.form["role"]
        salary = float(request.form["salary"])

        # Update the staff member in the database
        cursor.execute(
            "UPDATE Staff SET Fname = %s, Lname = %s, Role = %s, Salary = %s WHERE StaffID = %s",
            (fname, lname, role, salary, staff_id),
        )
        db.commit()

        return redirect("/staff_management")


# Route for deleting a staff member
@app.route("/delete_staff", methods=["GET"])
def delete_staff():
    # Retrieve the staff member ID from the query parameters
    staff_id = request.args.get("staff_id")

    # Delete the staff member from the database
    cursor.execute("DELETE FROM Staff WHERE StaffID = %s", (staff_id,))
    db.commit()

    return redirect("/staff_management")


# Route for the event management page
@app.route("/event_management")
def event_management():
    try:
        # Fetch events from the database
        cursor.execute("SELECT * FROM Event")
        events = cursor.fetchall()
        return render_template("event_management.html", events=events)
    except Exception as e:
        return f"An error occurred: {str(e)}"


# Route for adding an event
@app.route("/add_event", methods=["POST"])
def add_event():
    event_name = request.form["eventName"]
    event_date = request.form["eventDate"]
    event_location = request.form["eventLocation"]
    event_description = request.form["eventDescription"]

    # Insert the new event into the database
    cursor.execute(
        "INSERT INTO Event (EventName, Date, Location, Description) VALUES (%s, %s, %s, %s)",
        (event_name, event_date, event_location, event_description),
    )
    db.commit()

    # Redirect to the event management route to refresh the page
    return redirect("/event_management")


# Route for editing an event
@app.route("/edit_event", methods=["GET", "POST"])
def edit_event():
    if request.method == "GET":
        # Retrieve the event ID from the query parameters
        event_id = request.args.get("event_id")

        # Fetch the event details from the database
        cursor.execute("SELECT * FROM Event WHERE EventID = %s", (event_id,))
        event = cursor.fetchone()

        return render_template("edit_event.html", event=event)
    elif request.method == "POST":
        # Retrieve updated event details from the form
        event_id = request.form["event_id"]
        event_name = request.form["event_name"]
        event_date = request.form["event_date"]
        event_location = request.form["event_location"]
        event_description = request.form["event_description"]

        # Update the event in the database
        cursor.execute(
            "UPDATE Event SET EventName = %s, Date = %s, Location = %s, Description = %s WHERE EventID = %s",
            (event_name, event_date, event_location, event_description, event_id),
        )
        db.commit()

        return redirect("/event_management")


# Route for deleting an event
@app.route("/delete_event", methods=["GET"])
def delete_event():
    # Retrieve the event ID from the query parameters
    event_id = request.args.get("event_id")

    # Delete the event from the database
    cursor.execute("DELETE FROM Event WHERE EventID = %s", (event_id,))
    db.commit()

    return redirect("/event_management")


@app.route("/calculator")
def calculator():
    return render_template("calculator.html")


if __name__ == "__main__":
    app.run(debug=True)
