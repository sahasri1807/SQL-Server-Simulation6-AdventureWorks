-- ============================================================================
-- Owner: Lien
-- Task 6 Part A
-- Report 1 - Product Price Audit History
-- Report 2 - Prevented Deletion Attempts

USE AdventureWorks2022;  
GO                      

-- SECURITY: LEAST-PRIVILEGE ACCESS TO AUDIT DATA
IF NOT EXISTS (SELECT 1                         
               FROM sys.database_principals     
               WHERE name = 'AuditReader'       
                 AND type = 'R')                
BEGIN
    CREATE ROLE AuditReader;                    
END;
GO                                              

GRANT SELECT ON Training.ProductPriceAudit TO AuditReader;     
GRANT SELECT ON Training.ProductDeletionAudit TO AuditReader;  
GO                                                             



-- Report 1 - Product Price Audit History (SDS output names via aliases)
DECLARE @FromDate DATETIME2 = '1900-01-01';      
DECLARE @ToDate   DATETIME2 = SYSDATETIME();     
DECLARE @MaxRows  INT       = 10000;             

SELECT TOP (@MaxRows)                            
    ppa.AuditID,                                 
    ppa.ProductID,                               
    ppa.ProductName,                             
    ppa.PreviousPrice AS OldPrice,               
    ppa.UpdatedPrice  AS NewPrice,               
    ppa.UpdatedPrice - ppa.PreviousPrice AS PriceDifference,  
    ppa.ModifiedBy    AS ChangedBy,              
    ppa.ChangeDate                               
FROM Training.ProductPriceAudit AS ppa           
WHERE ppa.ChangeDate >= @FromDate                
  AND ppa.ChangeDate <= @ToDate                  
ORDER BY ppa.ChangeDate DESC;                    
GO                                               

-- Report 2 - Prevented Deletion Attempts (SDS output names via aliases)
DECLARE @FromDate DATETIME2 = '1900-01-01';      
DECLARE @ToDate   DATETIME2 = SYSDATETIME();     
DECLARE @MaxRows  INT       = 10000;             

SELECT TOP (@MaxRows)                            
    pda.AuditID,                                 
    pda.ProductID,                               
    pda.ProductName,                             
    pda.AttemptingUser AS AttemptedBy,           
    pda.AttemptTime    AS AttemptDate,          
    pda.Reason                                   
FROM Training.ProductDeletionAudit AS pda        
WHERE pda.AttemptTime >= @FromDate               
  AND pda.AttemptTime <= @ToDate                 
ORDER BY pda.AttemptTime DESC;                   
GO                                               

-- ============================================================================
-- Task: Audit reporting queries for simulation deliverables.
-- Implementation: Team members add SQL below this header.
-- ============================================================================
