-- ============================================================================
-- Owner: Brian (Task 2 - trg_Product_PriceAudit)
-- ============================================================================
-- Task: After UPDATE trigger to audit product price changes.
-- ============================================================================

USE AdventureWorks2022;
GO

DROP TRIGGER IF EXISTS Production.trg_Product_PriceAudit;
GO

CREATE OR ALTER TRIGGER trg_Product_PriceAudit
ON Production.Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Trigger should only run when ListPrice is modified
    IF NOT UPDATE(ListPrice)
        RETURN;

    INSERT INTO Training.ProductPriceAudit
    (
        ProductID,
        OldPrice,
        NewPrice,
        ChangedBy
    )
    SELECT
        i.ProductID,
        d.ListPrice,
        i.ListPrice,
        ISNULL(SUSER_SNAME(), ORIGINAL_LOGIN())
    FROM inserted AS i
    INNER JOIN deleted AS d
        ON i.ProductID = d.ProductID
    WHERE d.ListPrice <> i.ListPrice;

END;
GO


-- Prevent modification or deletion of audit records
DENY UPDATE, DELETE ON Training.ProductPriceAudit TO PUBLIC;
GO