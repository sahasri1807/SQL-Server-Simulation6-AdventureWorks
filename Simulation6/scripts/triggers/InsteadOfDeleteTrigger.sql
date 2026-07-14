-- ============================================================================
-- Owner: Parth (Task 3 - trg_Product_PreventDelete)
-- ============================================================================
-- Task: INSTEAD OF DELETE trigger to prevent product deletion.
-- ============================================================================

USE AdventureWorks2022;
GO

DROP TRIGGER IF EXISTS Production.trg_Product_PreventDelete;
GO

CREATE OR ALTER TRIGGER trg_Product_PreventDelete
ON Production.Product
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Training.ProductDeletionAudit
    (
        ProductID,
        ProductName,
        AttemptedBy,
        Reason
    )
    SELECT
        d.ProductID,
        d.Name,
        ISNULL(SUSER_SNAME(), ORIGINAL_LOGIN()),
        'Deletion prevented: Product is referenced by customer transactions.'
    FROM deleted d
    WHERE EXISTS
    (
        SELECT 1
        FROM Sales.SalesOrderDetail s
        WHERE s.ProductID = d.ProductID
    );


    DELETE p
    FROM Production.Product p
    INNER JOIN deleted d
        ON p.ProductID = d.ProductID
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM Sales.SalesOrderDetail s
        WHERE s.ProductID = d.ProductID
    );

END;
GO


