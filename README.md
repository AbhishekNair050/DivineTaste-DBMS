# Divine Taste Database Management System

The Divine Taste Database Management System (DBMS) is a comprehensive solution designed to streamline and optimize the operations of Divine Taste Bakery. This system provides a user-friendly interface for managing various aspects of the bakery, including product inventory, orders, events, suppliers, staff, and customer information.

## Features

- **Product Management**: Maintain a comprehensive database of bakery products, including their descriptions, prices, quantities, and categories.
- **Order Management**: Efficiently handle customer orders, track order details, delivery information, and payment details.
- **Event Management**: Organize and manage bakery events, including event details, staff assignments, and associated orders.
- **Supplier Management**: Keep track of suppliers, their contact information, and the ingredients they provide.
- **Staff Management**: Manage staff details, roles, salaries, and their assignments to events and orders.
- **Customer Management**: Store customer information, contact details, and order history.
- **Reporting and Analytics**: Generate insightful reports and analyze data to support decision-making processes.
- **Data Integrity**: Ensure data consistency and accuracy through normalization and robust validation mechanisms.
- **User-friendly Interface**: Provide an intuitive and visually appealing web-based interface for seamless interaction with the system.

## Technologies Used

- **Backend**: Python, Flask, MySQL
- **Frontend**: HTML, CSS, JavaScript
- **Database**: MySQL
- **Libraries and Frameworks**: Flask, SQLAlchemy, Jinja2

## Getting Started

### Prerequisites

- Python (version 3.6 or higher)
- MySQL Server

### Installation

1. Clone the repository:

```
git clone https://github.com/your-username/divine-taste-dbms.git
```

2. Navigate to the project directory:

```
cd divine-taste-dbms
```

3. Create a virtual environment and activate it:

```
python -m venv env
source env/bin/activate  # On Windows, use `env\Scripts\activate`
```

4. Install the required dependencies:

```
pip install -r requirements.txt
```

5. Set up the MySQL database by running the SQL script provided in the `database` directory.

6. Configure the database connection details in the `config.py` file.

### Running the Application

1. Start the Flask development server:

```
python app.py
```

2. Open your web browser and navigate to `http://localhost:5000` to access the Divine Taste DBMS.

### Frontend

The frontend of the Divine Taste DBMS is built using HTML, CSS, and JavaScript. To run the frontend, follow these steps:

1. Make sure the Flask development server is running (see the "Running the Application" section above).

2. Open your web browser and navigate to `http://localhost:5000`.

3. You should now see the user interface of the Divine Taste DBMS.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.
.

## Acknowledgments

We would like to express our gratitude to the following resources and communities for their valuable contributions and support:

- [Flask Documentation](https://flask.palletsprojects.com/en/2.2.x/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/en/14/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Stack Overflow](https://stackoverflow.com/)
- [GitHub Community](https://github.com/)
