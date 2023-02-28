USE H_Accounting;

DELIMITER $$
DROP PROCEDURE IF EXISTS H_Accounting.testexp8; -- if error says access denied, instead of dropping change name of procedure
CREATE PROCEDURE H_Accounting.testexp8(varCalendarYear SMALLINT) -- user will input the year (so you are defining what to ask)
BEGIN
  
	-- We receive as an argument the year for which we will calculate the revenues
    -- This value is stored as an 'YEAR' type in the variable `varCalendarYear`
  
	-- Part 1: Define the variables you want to use 
    -- -----------------------------------------------------------------------------------------
	
    -- Current Year Variables
    DECLARE varTotalRevenues DOUBLE DEFAULT 0; 
    DECLARE varReturns	 	 DOUBLE DEFAULT 0;
    DECLARE varCogs 		 DOUBLE DEFAULT 0;
    DECLARE varAdminExp	 	 DOUBLE DEFAULT 0;
    DECLARE varSellingExp	 DOUBLE DEFAULT 0;
    DECLARE varOtherExp		 DOUBLE DEFAULT 0;
    DECLARE varOtherInc		 DOUBLE DEFAULT 0;
    DECLARE varTax			 DOUBLE DEFAULT 0;
    DECLARE varOtherTax		 DOUBLE DEFAULT 0;
    DECLARE varProfit		 DOUBLE DEFAULT 0;
    
    -- Last Year Variables
    DECLARE varTotalRevenuesLY DOUBLE DEFAULT 0; 
    DECLARE varReturnsLY	   DOUBLE DEFAULT 0;
    DECLARE varCogsLY 		   DOUBLE DEFAULT 0;
    DECLARE varAdminExpLY	   DOUBLE DEFAULT 0;
    DECLARE varSellingExpLY	   DOUBLE DEFAULT 0;
    DECLARE varOtherExpLY	   DOUBLE DEFAULT 0;
    DECLARE varOtherIncLY	   DOUBLE DEFAULT 0;
    DECLARE varTaxLY		   DOUBLE DEFAULT 0;
    DECLARE varOtherTaxLY	   DOUBLE DEFAULT 0;
    DECLARE varProfitLY		   DOUBLE DEFAULT 0;
    
  -- Part 2: Create the code to get the values
  -- -------------------------------------------------------------------------------------------------------------------
  
	--  We calculate the value of the sales for the given year and we store it into the variable we just declared
    
    -- Current Year 
    
    SELECT (
			CASE 
			WHEN SUM(jeli.debit) IS NULL THEN 0
			ELSE SUM(jeli.debit) END 
		   )INTO varTotalRevenues
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "REV"
	 AND YEAR(je.entry_date) = varCalendarYear
		;
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varReturns
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "RET"
	 AND YEAR(je.entry_date) = varCalendarYear
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varCogs
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "COGS"
	 AND YEAR(je.entry_date) = varCalendarYear
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varAdminExp	
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "GEXP"
	 AND YEAR(je.entry_date) = varCalendarYear
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varSellingExp
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "SEXP"
	 AND YEAR(je.entry_date) = varCalendarYear
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varOtherExp
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OEXP"
	 AND YEAR(je.entry_date) = varCalendarYear
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.debit) IS NULL THEN 0
			ELSE SUM(jeli.debit) END 
		   )INTO varOtherInc
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OI"
	 AND YEAR(je.entry_date) = varCalendarYear
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varTax
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "INCTAX"
	 AND YEAR(je.entry_date) = varCalendarYear
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varOtherTax
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OTHTAX"
	 AND YEAR(je.entry_date) = varCalendarYear
		;

-- Last Year Code

SELECT (
			CASE 
			WHEN SUM(jeli.debit) IS NULL THEN 0
			ELSE SUM(jeli.debit) END 
		   )INTO varTotalRevenuesLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "REV"
	 AND YEAR(je.entry_date) = (varCalendarYear - 1)
		;
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varReturnsLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "RET"
	 AND YEAR(je.entry_date) = (varCalendarYear - 1)
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varCogsLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "COGS"
	 AND YEAR(je.entry_date) = (varCalendarYear - 1)
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varAdminExpLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "GEXP"
	 AND YEAR(je.entry_date) = (varCalendarYear - 1 )
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varSellingExpLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "SEXP"
	 AND YEAR(je.entry_date) = (varCalendarYear - 1 )
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varOtherExpLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OEXP"
	  AND YEAR(je.entry_date) = (varCalendarYear - 1 )
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.debit) IS NULL THEN 0
			ELSE SUM(jeli.debit) END 
		   )INTO varOtherIncLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OI"
	 AND YEAR(je.entry_date) = (varCalendarYear - 1)
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varTaxLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "INCTAX"
	 AND YEAR(je.entry_date) = (varCalendarYear - 1)
		;
        
	SELECT (
			CASE 
			WHEN SUM(jeli.credit) IS NULL THEN 0
			ELSE SUM(jeli.credit) END 
		   )INTO varOtherTaxLY
	FROM H_Accounting.journal_entry_line_item AS jeli
	INNER JOIN H_Accounting.`account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN H_Accounting.journal_entry  AS je 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN H_Accounting.statement_section AS ss 
			ON ss.statement_section_id = ac.profit_loss_section_id
	WHERE ss.statement_section_code = "OTHTAX"
	 AND YEAR(je.entry_date) = (varCalendarYear - 1)
		;

-- Part 3: time to create the structure of the table, lets start making the divisions (you cant change the tem table name)
-- -----------------------------------------------------------------------------------------------------------

	DROP TABLE IF EXISTS H_Accounting.jcarrillo_tmp;
	CREATE TABLE H_Accounting.jcarrillo_tmp
	(N_line INT, Title VARCHAR(50), Amount VARCHAR(50), Change_years VARCHAR(50));
  
-- Part 4: Time to inject the values in each row

  -- Insert the a header for the report
    INSERT INTO H_Accounting.jcarrillo_tmp
		      (N_line, Title, Amount, Change_years)
    VALUES  (1, 'PROFIT AND LOSS STATEMENT', "In Thousands USD", '% change');
  
	-- Next we insert an empty line to create some space between the header and the line items
	INSERT INTO H_Accounting.jcarrillo_tmp
				(N_line, Title, Amount, Change_years)
	VALUES 	(2, '', '','');
    
	-- Insert each row with its value
	INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(3, 'Total Revenues', format(varTotalRevenues / 1000, 2), format(ifnull( (varTotalRevenues - varTotalRevenuesLY)/NULLIF(varTotalRevenuesLY,0)*100,0),2));
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(4, 'Returns', format(varReturns / 1000, 2), format(ifnull( (varReturns - varReturnsLY)/NULLIF(varReturnsLY,0)*100,0),2));
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(5, 'Cost of Goods Sold', format(varCogs / 1000, 2), format(ifnull( (varCogs - varCogsLY)/NULLIF(varCogsLY,0)*100,0),2));
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(6, 'Administrative Expenses', format(varAdminExp / 1000, 2), format(ifnull( (varAdminExp - varAdminExpLY)/NULLIF(varAdminExpLY,0)*100,0),2));
    
	INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(7, 'Selling Expenses', format(varSellingExp / 1000, 2), format(ifnull( (varSellingExp - varSellingExpLY)/NULLIF(varSellingExpLY,0)*100,0),2));
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(8, 'Other Expenses', format(varOtherExp / 1000, 2), format(ifnull( (varOtherExp - varOtherExpLY)/NULLIF(varOtherExpLY,0)*100,0),2));
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(9, 'Other Income', format(varOtherInc / 1000, 2), format(ifnull( (varOtherInc - varOtherIncLY)/NULLIF(varOtherIncLY,0)*100,0),2));
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(10, 'Income Tax', format(varTax / 1000, 2), format(ifnull( (varTax - varTaxLY)/NULLIF(varTaxLY,0)*100,0),2));
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(11, 'Other Tax', format(varOtherTax / 1000, 2), format(ifnull( (varOtherTax - varOtherTaxLY)/NULLIF(varOtherTaxLY,0)*100,0),2));
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES 	(12, '', '','');
    
    INSERT INTO H_Accounting.jcarrillo_tmp
			(N_line, Title, Amount, Change_years)
	VALUES  (13,'Profit or Loss', FORMAT( ( ( ( varTotalRevenues + varOtherInc - varCogs) - varSellingExp - varOtherExp) - varTax)  /1000, 2), '' );

END $$
DELIMITER ;
# THE LINE ABOVES CHANGES BACK OUR DELIMETER TO OUR USUAL ;

-- call the procedure 
CALL H_Accounting.testexp8(2015);

SELECT * FROM H_Accounting.jcarrillo_tmp;


-- CODES needed
-- SELECT *
-- FROM statement_section
