-- Analyzing Data

SELECT *
FROM warehouses_staging;

SELECT *
FROM productlines_staging;

SELECT *
FROM products_staging;

-- Question 1. Where are the products stored and if they are rearranged can a warehouse be elimated?
-- Question 2. How are inventory related to sales figure? Do the inventory count seem appropriate for each item?
-- Question 3. Are we storing items that are not moving? Are anu item candidates for  dropping from the product line?


SELECT 
    w.warehouse_code,
    p.product_name
FROM warehouses_staging w
JOIN products_staging p 
    ON w.warehouse_code = p.warehouse_code
ORDER BY w.warehouse_code, p.product_name;
-- This list all of the items stored at each warehouse.

SELECT 
    w.warehouse_code,
    COUNT(p.product_code) AS totalProducts
FROM warehouses_staging w
JOIN products_staging p 
    ON w.warehouse_code = p.warehouse_code
GROUP BY w.warehouse_code
ORDER BY totalProducts DESC;
-- Warehouse b has 38 different products
-- Warehouse a has 25 different products
-- Warehouse c has 24 different products
-- Ware house d has 23 different products

 
SELECT 
    w.warehouse_code,
    pl.product_line,
    COUNT(DISTINCT p.product_code) AS product_count
FROM warehouses_staging w
JOIN products_staging p 
    ON w.warehouse_code = p.warehouse_code
JOIN productlines_staging pl 
    ON p.product_line = pl.product_line
GROUP BY w.warehouse_code, pl.product_line
ORDER BY w.warehouse_code, product_count DESC;

-- View the productlines at each warehouse
-- Warehouse a - Motorcycles (13), Planes (12)
-- Warehouse b - Classic Cars (38) 
-- Warehouse c - Vintage Cars (24)
-- Warehouse d - Trucks and Buses (11), Ships (9), Trains (3)


SELECT 
    w.warehouse_code,
    pl.product_line,
    SUM(p.quantity_in_stock) AS total_stock,
    COUNT( DISTINCT p.product_code) AS number_of_products
FROM warehouses_staging w
JOIN products_staging p 
    ON w.warehouse_code = p.warehouse_code
JOIN productlines_staging pl
    ON p.product_line = pl.product_line
GROUP BY w.warehouse_code, pl.product_line
ORDER BY w.warehouse_code, total_stock DESC;

-- Sum of productline for each warehouses in descending order is
-- Warehouse a - Motorcycles - 69401
-- Warehouse a - Planes - 62287
-- Warehouse b - Classic Cars - 219183
-- Warehouse c - Vintage Cars - 124880
-- Warehouse d - Trucks and Buses - 35851
-- Warehouse d - Ships - 26833
-- Warehose d - Trains - 16696

-- Question 2. How are inventory related to sales figure 

SELECT 
    pl.product_line,
    w.warehouse_code,
    SUM(p.quantity_in_stock) AS total_inventory,
    SUM(od.quantity_ordered * od.price_each) AS total_sales
FROM
    products_staging p
        JOIN
    productlines_staging pl ON p.product_line = pl.product_line
        JOIN
    warehouses_staging w ON p.warehouse_code = w.warehouse_code
        LEFT JOIN
    orderdetails_staging od ON p.product_code = od.product_code
        LEFT JOIN
    orders_staging o ON od.order_number = o.order_number
GROUP BY pl.product_line , w.warehouse_code
ORDER BY pl.product_line , w.warehouse_code;

-- inventory related to sales 
-- Warehouse a - Motorcycles           total_inventory 1915517  total_sales $1121426.12
-- Warehouse a - Planes                total_inventory 1744036 total_sales $954637.54
-- Warehouse b - Classic Cars          total_inventory 5851766  total_sales $3853922.49
-- Warehouse c - Vintage Cars          total_inventory 3439570  total_sales $ 1797559.63
-- Warehouse d -  Ships                total_inventory 732251 total_sales  $663998.34
-- Warehouse d - Trains                total_inventory 450792 total_sales  $188532.92
-- Warehouse d - Trucks and Buses      total_inventory 1003828 total_sales  $1024113.57


-- Question Does the inventory count seem appropriate for each item?

SELECT 
    p.product_code,
    p.product_name,
    pl.product_line,
    w.warehouse_code,
    p.quantity_in_stock AS current_inventory,
    COALESCE(SUM(od.quantity_ordered), 0) AS total_units_sold,
    CASE 
        WHEN SUM(od.quantity_ordered) IS NULL OR SUM(od.quantity_ordered) = 0 THEN 'Low demand'
        WHEN p.quantity_in_stock > SUM(od.quantity_ordered) * 5 THEN 'Overstocked'
        WHEN p.quantity_in_stock < SUM(od.quantity_ordered) * 0.5 THEN 'Risk of stockout'
        ELSE 'Balanced'
    END AS inventory_status
FROM products_staging p
JOIN productlines_staging pl
    ON p.product_line = pl.product_line
JOIN warehouses_staging w
    ON p.warehouse_code = w.warehouse_code
LEFT JOIN orderdetails_staging od
    ON p.product_code = od.product_code
LEFT JOIN orders_staging o
    ON od.order_number = o.order_number
GROUP BY p.product_code, p.product_name, pl.product_line, w.warehouse_code, p.quantity_in_stock
ORDER BY inventory_status, p.product_line, p.product_name;

-- Items that seem to have appropriate inventory count
-- Most of the items have an appropriate inventory count with exceptions
-- Items that are low in stock:

-- product code  product name               productline    warehouse code  current inventory   units sold      inventory status
-- 	S12_1099	1968 Ford Mustang	        Classic Cars	b	            68              	933	           Risk of stockout
-- 	S24_2000	1960 BSA Gold Star DBD34	Motorcycles    	a	            15	                1015	       Risk of stockout
-- 	S32_1374	1997 BMW F650 ST	        Motorcycles	    a	            178	                1014	       Risk of stockout
-- 	S72_3212	Pont Yacht	                Ships	        d	            414             	958            Risk of stockout
-- 	S32_4289	1928 Ford Phaeton Deluxe	Vintage Cars	c	            136	                972	           Risk of stockout


-- Items that are overstocked
-- 	S18_1889	1948 Porsche 356-A Roadster	Classic Cars	b	          8826	              972	Overstocked
-- 	S18_3685	1948 Porsche Type 356 Roadster	Classic Cars	b	      8990	              948	Overstocked
-- 	S10_1949	1952 Alpine Renault 1300	Classic Cars	b	          7305	              961	Overstocked
-- 	S24_3856	1956 Porsche 356A Coupe	Classic Cars	b	              6600	              1052	 Overstocked
-- 	S24_4620	1961 Chevrolet Impala	Classic Cars	b	              7869	              941	Overstocked
-- 	S10_4962	1962 LanciaA Delta 16V	Classic Cars	b	              6791	              932	Overstocked
-- 	S18_1589	1965 Aston Martin DB5	Classic Cars	b	              9042	              914	Overstocked
-- 	S24_1628	1966 Shelby Cobra 427 S/C	Classic Cars	b	          8197                915	Overstocked
-- 	S12_3380	1968 Dodge Charger	Classic Cars	b	                  9123	              925	Overstocked
-- 	S24_3191	1969 Chevrolet Camaro Z28	Classic Cars	b	          4695	              870	Overstocked
-- 	S12_3148	1969 Corvair Monza	Classic Cars	b	                  6906	              963	Overstocked
-- 	S12_4675	1969 Dodge Charger	Classic Cars	b	                  7323	              992	Overstocked
-- 	S12_3990	1970 Plymouth Hemi Cuda	Classic Cars	b	              5663	              900	Overstocked
-- 	S18_4027	1970 Triumph Spitfire	Classic Cars	b	              5545	              945	Overstocked
-- 	S24_3371	1971 Alpine Renault 1600s	Classic Cars	b	          7995	              969	Overstocked
-- 	S18_3482	1976 Ford Gran Torino	Classic Cars	b	              9127	              915	Overstocked
-- 	S700_2824	1982 Camaro Z28	Classic Cars	b	                      6934	              997	Overstocked
-- 	S24_2972	1982 Lamborghini Diablo	Classic Cars	b	              7723	              912	Overstocked
-- 	S24_4048	1992 Porsche Cayenne Turbo Silver	Classic Cars	b	  6582	              867	Overstocked
-- 	S18_1984	1995 Honda Civic	Classic Cars	b	                  9772	             917	Overstocked
-- 	S18_2870	1999 Indy 500 Monte Carlo SS	Classic Cars	b	      8164	             855	Overstocked
-- 	S24_3432	2002 Chevy Corvette	Classic Cars	b	                  9446	             894	Overstocked
-- 	S18_3782	1957 Vespa GS150	Motorcycles	a	                      7689	             959	Overstocked
-- 	S10_1678	1969 Harley Davidson Ultimate Chopper	Motorcycles	a	  7933	             1057	Overstocked
-- 	S24_2360	1982 Ducati 900 Monster	Motorcycles	a	                  6840	             947	Overstocked
-- 	S32_2206	1982 Ducati 996 R	Motorcycles	a	                      9241	             906	Overstocked
-- 	S10_2016	1996 Moto Guzzi 1100i	Motorcycles	a	                  6625	             999	Overstocked
-- 	S24_1578	1997 BMW R 1100 S	Motorcycles	a	                      7003	             1033	Overstocked
-- 	S12_2823	2002 Suzuki XREO	Motorcycles	a	                      9997	             1028	Overstocked
-- 	S10_4698	2003 Harley-Davidson Eagle Drag Bike	Motorcycles	a	  5582	             985	Overstocked
-- 	S24_2841	1900s Vintage Bi-Plane	Planes	a	                      5942	             940	Overstocked
-- 	S18_1662	1980s Black Hawk Helicopter	Planes	a	                  5330	             1040	Overstocked
-- 	S700_2466	America West Airlines B757-200	Planes	a	              9653	             984	Overstocked
-- 	S700_1691	American Airlines: B767-300	Planes	a	                  5841	             894	Overstocked
-- 	S700_4002	American Airlines: MD-11S	Planes	a	                  8820	             1085	Overstocked
-- 	S700_2834	ATA: B757-300	Planes	a	                              7106	              973	Overstocked
-- 	S72_1253	Boeing X-32A JSF	Planes	a	                          4857	              960	Overstocked
-- 	S24_3949	Corsair F4U ( Bird Cage)	Planes	a	                  6812	              1051	Overstocked
-- 	S700_3962	The Queen Mary	Ships	d	                              5088	              896	Overstocked
-- 	S700_2610	The USS Constitution Ship	Ships	d	                  7083	             1020	Overstocked
-- 	S32_3207	1950's Chicago Surface Lines Streetcar	Trains	d      	  8601	             934	Overstocked
-- 	S18_3259	Collectable Wooden Train	Trains	d	                  6450	             918	Overstocked
-- 	S12_4473	1957 Chevy Pickup	Trucks and Buses	d	              6125	             1056	Overstocked
-- 	S18_2319	1964 Mercedes Tour Bus	Trucks and Buses	d	          8258	             1053	Overstocked
-- 	S32_1268	1980’s GM Manhattan Express	Trucks and Buses	d	      5099	             911	Overstocked
-- 	S18_3136	18th Century Vintage Horse Carriage	Vintage Cars	c	  5992	             907	Overstocked
-- 	S18_4522	1904 Buick Runabout	Vintage Cars	c	                  8290	             990	Overstocked
-- 	S24_3151	1912 Ford Model T Delivery Wagon	Vintage Cars	c	  9173	             991	Overstocked
-- 	S18_3320	1917 Maxwell Touring Car	Vintage Cars	c	          7913	             992	Overstocked
-- 	S50_1341	1930 Buick Marquette Phaeton	Vintage Cars	c	      7062	            1074	Overstocked
-- 	S18_4409	1932 Alfa Romeo 8C2300 Spider Sport	Vintage Cars	c	  6553	            866	    Overstocked
-- 	S18_2325	1932 Model A Ford J-Coupe	Vintage Cars	c	          9354	            957	    Overstocked
-- 	S18_2957	1934 Ford V8 Coupe	Vintage Cars	c	                  5649	            985	    Overstocked
-- 	S18_1367	1936 Mercedes-Benz 500K Special Roadster	Vintage Cars	c	8635	    960	    Overstocked
-- 	S18_1342	1937 Lincoln Berline	Vintage Cars	c	              8693	            1111	Overstocked
-- 	S18_4668	1939 Cadillac Limousine	Vintage Cars	c	              6645	            995	    Overstocked
-- 	S24_1937	1939 Chevrolet Deluxe Coupe	Vintage Cars	c	          7332	            937	    Overstocked
-- 	S24_3816	1940 Ford Delivery Sedan	Vintage Cars	c	          6621	            923	    Overstocked



-- Question 3. Are we storing items that are not moving

SELECT 
    p.product_code,
    p.product_name,
    pl.product_line,
    w.warehouse_code,
    p.quantity_in_stock,
    COALESCE(SUM(od.quantity_ordered), 0) AS total_units_sold,
    CASE 
        WHEN SUM(od.quantity_ordered) IS NULL OR SUM(od.quantity_ordered) = 0 THEN 'No sales'
        WHEN SUM(od.quantity_ordered) < (p.quantity_in_stock * 0.1) THEN 'Slow moving'
        ELSE 'Moving'
    END AS movement_status
FROM products_staging p
JOIN productlines_staging pl
    ON p.product_line = pl.product_line
JOIN warehouses_staging w
    ON p.warehouse_code = w.warehouse_code
LEFT JOIN orderdetails_staging od
    ON p.product_code = od.product_code
LEFT JOIN orders_staging o
    ON od.order_number = o.order_number
GROUP BY p.product_code, p.product_name, pl.product_line, w.warehouse_code, p.quantity_in_stock
HAVING SUM(od.quantity_ordered) IS NULL 
   OR SUM(od.quantity_ordered) = 0 
   OR SUM(od.quantity_ordered) < (p.quantity_in_stock * 0.1)
ORDER BY movement_status, p.product_line, p.product_name;

-- Warehouse b-  product 1985 Toyota Supra (no sales)

-- Products that are slow moving compared to stock level
-- Warehouse b products 1995 Honda Civic
-- Warehouse b 2002 Chevy Corvette
-- Warehouse a  1982 Ducati 996 R 



-- Warehouse best candidate for closure


--  Warehouse a - Motorcycles         total_inventory 1915517  total_sales $1121426.12   
-- Warehouse a - Planes                total_inventory 1744036 total_sales $954637.54        
-- Warehouse b - Classic Cars          total_inventory 5851766  total_sales $3853922.49      
-- Warehouse c - Vintage Cars          total_inventory 3439570  total_sales $ 1797559.63     
-- Warehouse d -  Ships                total_inventory 732251 total_sales  $663998.34         
-- Warehouse d - Trains                total_inventory 450792 total_sales  $188532.92         
-- Warehouse d - Trucks and Buses      total_inventory 1003828 total_sales  $1024113.57

-- Sales revenue for each warehouse
SELECT 
    w.warehouse_code,
    SUM(od.quantity_ordered * od.price_each) AS total_sales
FROM warehouses_staging w
JOIN products_staging p ON w.warehouse_code = p.warehouse_code
JOIN orderdetails_staging od ON p.product_code = od.product_code
GROUP BY w.warehouse_code;

-- Total Sales by warehouse
-- 	warehouse_code	total_sales
-- 	a	            2076063.66
-- 	b	            3853922.49
-- 	c	            1797559.63
-- 	d	            1876644.83

-- Total inventory at each warehouse
SELECT 
    w.warehouse_code,
    SUM(p.quantity_in_stock) AS total_stock
FROM warehouses_staging w
JOIN products_staging p ON w.warehouse_code = p.warehouse_code
GROUP BY w.warehouse_code;

-- Warehouse a  131688
-- Warehouse b	219183
-- Warehouse c	124880 
-- Warehouse d  79380

-- Calculate sales per stock
-- This would determine which warehouse is a good candidate for closure

SELECT 
    w.warehouse_code,
    SUM(od.quantity_ordered * od.price_each) AS total_sales,
    SUM(p.quantity_in_stock) AS total_stock,
    ROUND(
        SUM(od.quantity_ordered * od.price_each) * 1.0 / NULLIF(SUM(p.quantity_in_stock), 0), 
        2
    ) AS sales_per_stock
FROM warehouses_staging w
JOIN products_staging p ON w.warehouse_code = p.warehouse_code
JOIN orderdetails_staging od ON p.product_code = od.product_code
GROUP BY w.warehouse_code
ORDER BY sales_per_stock ASC;

-- Results to determine closure of warehouse
-- 	warehouse_code	      total_sales	     total_stock	   sales_per_stock
-- 	c	                  1797559.63	      3439570	         0.52
-- 	a	                  2076063.66	      3659553	         0.57
-- 	b	                  3853922.49	      5844033	         0.66
-- 	d	                  1876644.83	      2186871	         0.86

-- Warehouse c is the best candidate for closure
-- It has sales per stock at 0.52
-- which means it is storing alot of inventory with little sales














