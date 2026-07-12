-- ============================================================================
-- Owner: Brian (Task 2 - trg_Product_PriceAudit)
-- Task: After UPDATE trigger to audit product price changes.
-- ============================================================================
USE AdventureWorks2022;
GO     

DROP TRIGGER IF EXISTS Production.trg_Product_PriceAudit; -- In case a trigger of the same name exists elsewhere in the schema. 
                                                          -- A DML trigger's name must be unique within its schema.
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
        ISNULL(SUSER_SNAME(), ORIGINAL_LOGIN()) -- SUSER_SNAME() is used here in accordance with the Software Design Specification 21.3; 
                                                -- ORIGINAL_LOGIN() refers to the login that truly opened this connection, EXECUTE AS cannot fake it, and it is never NULL.
    FROM inserted AS i                          
    INNER JOIN deleted AS d                     
        ON d.ProductID = i.ProductID            
    WHERE d.ListPrice <> i.ListPrice;           
END;                                            
GO                                              

-- The DENY command enforces Software Development Specification immutability requirements (sections 7 and 12.3)...
-- by preventing any user from modifying or deleting audit records, 
-- ensuring the historical price-change data remains permanently tamper-proof regardless of future permission changes.
DENY UPDATE, DELETE ON Training.ProductPriceAudit TO PUBLIC;  
GO
