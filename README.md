# Analyze-data-in-a-model-car-dataset-with-MySQL-workbench
This project provides analytic insights and data driven recommendations

Project Scenario

Mint Classics Company, a retailer of classic model cars and other vehicles, is looking at closing one of their storage facilities. 

To support a data-based business decision, they are looking for suggestions and recommendations for reorganizing or reducing inventory, while still maintaining timely service to their customers. For example, they would like to be able to ship a product to a customer within 24 hours of the order being placed.

As a data analyst, you have been asked to use MySQL Workbench to familiarize yourself with the general business by examining the current data. You will be provided with a data model and sample data tables to review. You will then need to isolate and identify those parts of the data that could be useful in deciding how to reduce inventory. You will write queries to answer questions like these:

1) Where are items stored and if they were rearranged, could a warehouse be eliminated?

2) How are inventory numbers related to sales figures? Do the inventory counts seem appropriate for each item?

3) Are we storing items that are not moving? Are any items candidates for being dropped from the product line?


<img width="1343" height="689" alt="Warehouse" src="https://github.com/user-attachments/assets/5a9eb481-9d86-4cd8-9050-96b3a6184e46" />

Total inventory at each of the four warehouses


<img width="1043" height="689" alt="Sales" src="https://github.com/user-attachments/assets/93cf8485-329c-4161-9034-b0d1bffe0144" />

Total revenue generated from each warehouse


<img width="1038" height="689" alt="Inventory Status" src="https://github.com/user-attachments/assets/468bf92e-7828-4cf0-bc9d-f92d1c56cb85" />

Status of inventory


<img width="901" height="689" alt="Products not moving" src="https://github.com/user-attachments/assets/d789df7a-a1fa-431e-8fda-9cc87ccff824" />

Inventory that are not moving


<img width="1018" height="794" alt="Sales per Stock (1)" src="https://github.com/user-attachments/assets/6e0b7a8a-7985-4899-bfb3-894f2156c2d3" />

Warehouse c has the lowest sales-to-stock


Recommendation

Warehouse c shows the lowest sales-to-stock ratio 0.52% 

Close warehouse c to reduce cost and improve efficiency

Move warehouse c inventory to a better performing warehouse 

Move inventory to warehouse d which has a 0.86% sales-to-stock ratio

Low demand items can be sold at a discount price and phased out

Focus investment on high performing warehouses and product lines





