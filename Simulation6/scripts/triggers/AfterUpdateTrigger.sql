-- ============================================================================
-- Owner: Brian (Task 2 - trg_Product_PriceAudit)
-- Task: After UPDATE trigger to audit product price changes.
-- ============================================================================
USE AdventureWorks2022;
GO                     

CREATE OR ALTER TRIGGER trg_Product_PriceAudit  
ON Production.Product                           
AFTER UPDATE                                    
AS                                              
BEGIN                                           
    SET NOCOUNT ON;                             

    IF NOT UPDATE(ListPrice)                    
        RETURN;                                 

    INSERT INTO Training.ProductPriceAudit      
    (                                           
        ProductID,                              
        ProductName,                            
        PreviousPrice,                          
        UpdatedPrice,                           
        ModifiedBy                              
    )
    SELECT                                      
        i.ProductID,                            
        i.Name,                                 
        d.ListPrice,                            
        i.ListPrice,                            
        ISNULL(SUSER_SNAME(), ORIGINAL_LOGIN()) 
    FROM inserted AS i                          
    INNER JOIN deleted AS d                     
        ON d.ProductID = i.ProductID            
    WHERE d.ListPrice <> i.ListPrice;           
END;                                            
GO                                              

-- The DENY command enforces SDS immutability requirements (sections 7 and 12.3) by preventing any user from modifying or deleting audit records, 
-- ensuring the historical price-change data remains permanently tamper-proof regardless of future permission changes.
DENY UPDATE, DELETE ON Training.ProductPriceAudit TO PUBLIC;  
GO
