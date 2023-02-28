USE H_Accounting;

-- To start we need to Creating the procedure for the balance sheet
DELIMITER $$
DROP PROCEDURE IF EXISTS H_Accounting.newtestBS;
CREATE PROCEDURE H_Accounting.newtestBS(varCalendarYear SMALLINT) -- user will the input the year (so you are defining what to ask)
BEGIN

-- Part 1: first define and Declare all the variables we need to use to store the information

	DECLARE varCurrentAss  DOUBLE DEFAULT 0;
	DECLARE varFixedAss    DOUBLE DEFAULT 0;
	DECLARE varDeferredAss DOUBLE DEFAULT 0;
	DECLARE varCurrentLia  DOUBLE DEFAULT 0;
	DECLARE varLongTermLia DOUBLE DEFAULT 0;
	DECLARE varDeferLia    DOUBLE DEFAULT 0;
	DECLARE varTotalEquity DOUBLE DEFAULT 0;


	DECLARE varCurrentAssPY  DOUBLE DEFAULT 0;
	DECLARE varFixedAssPY    DOUBLE DEFAULT 0;
	DECLARE varDeferredAssPY DOUBLE DEFAULT 0;
	DECLARE varCurrentLiaPY  DOUBLE DEFAULT 0;
	DECLARE varLongTermLiaPY DOUBLE DEFAULT 0;
	DECLARE varDeferLiaPY 	 DOUBLE DEFAULT 0;
	DECLARE varTotalEquityPY DOUBLE DEFAULT 0;

	-- Part 2: create the codes to get the real values from the database

	SELECT 
		((CASE 
		 WHEN SUM(jeli.debit) IS NULL THEN 0
		 ELSE SUM(jeli.debit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(jeli.credit) IS NULL THEN 0
		 ELSE SUM(jeli.credit)
		END)) INTO varCurrentAss
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "CA"
	  AND YEAR(je.entry_date) = varCalendarYear;


	SELECT 
		((CASE 
		 WHEN SUM(jeli.debit) IS NULL THEN 0
		 ELSE SUM(jeli.debit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(jeli.credit) IS NULL THEN 0
		 ELSE SUM(jeli.credit)
		 END)) INTO varFixedAss
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "FA"
	  AND YEAR(je.entry_date) = varCalendarYear;


	SELECT 
		((CASE 
		 WHEN SUM(jeli.debit) IS NULL THEN 0
		 ELSE SUM(jeli.debit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(jeli.credit) IS NULL THEN 0
		 ELSE SUM(jeli.credit)
		 END))  INTO varDeferredAss
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "DA"
	  AND YEAR(je.entry_date) = varCalendarYear;


	SELECT 
		((CASE 
		 WHEN SUM(credit) IS NULL THEN 0
		 ELSE SUM(credit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(debit) IS NULL THEN 0
		 ELSE SUM(debit)
		 END)) INTO varCurrentLia
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "CL"
	  AND YEAR(je.entry_date) = varCalendarYear;


	SELECT 
		((CASE 
		 WHEN SUM(credit) IS NULL THEN 0
		 ELSE SUM(credit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(debit) IS NULL THEN 0
		 ELSE SUM(debit)
		 END))INTO varLongTermLia
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "LLL"
	  AND YEAR(je.entry_date) = varCalendarYear;


	SELECT 
		((CASE 
		 WHEN SUM(credit) IS NULL THEN 0
		 ELSE SUM(credit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(debit) IS NULL THEN 0
		 ELSE SUM(debit)
		END)) INTO varDeferLia
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "DL"
	  AND YEAR(je.entry_date) = varCalendarYear;


	SELECT 
		((CASE 
		 WHEN SUM(credit) IS NULL THEN 0
		 ELSE SUM(credit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(debit) IS NULL THEN 0
		 ELSE SUM(debit)
		 END))INTO varTotalEquity
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "EQ"
	  AND YEAR(je.entry_date) = varCalendarYear;


-- Space, codes for the prior year data

	SELECT 
		((CASE 
		 WHEN SUM(debit) IS NULL THEN 0
		 ELSE SUM(debit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(credit) is null then 0
		 ELSE SUM(credit)
		 END))
		INTO varCurrentAssPY
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "CA"
	  AND YEAR(je.entry_date) = (varCalendarYear - 1);

		
	SELECT 
		((CASE 
		 WHEN SUM(debit) IS NULL THEN 0
		 ELSE SUM(debit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(credit) is null then 0
		 ELSE SUM(credit)
		 END)) INTO varFixedAssPY
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "FA"
	  AND YEAR(je.entry_date) = (varCalendarYear - 1);


	SELECT 
		((CASE 
		 WHEN SUM(debit) IS NULL THEN 0
		 ELSE SUM(debit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(credit) is null then 0
		 ELSE SUM(credit)
		 END)) INTO varDeferredAssPY
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "DA"
	  AND YEAR(je.entry_date) = (varCalendarYear - 1);

		
	SELECT 
		((CASE 
		 WHEN SUM(credit) IS NULL THEN 0
		 ELSE SUM(credit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(debit) is null then 0
		 ELSE SUM(debit)
		 END)) INTO varCurrentLiaPY
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "CL"
	  AND YEAR(je.entry_date) = (varCalendarYear - 1);
	 
	SELECT 
		((CASE 
		 WHEN SUM(credit) IS NULL THEN 0
		 ELSE SUM(credit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(debit) is null then 0
		 ELSE SUM(debit)
		 END)) INTO varLongTermLiaPY
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "LLL"
	  AND YEAR(je.entry_date) = (varCalendarYear - 1);

		
	SELECT 
		((CASE 
		 WHEN SUM(credit) IS NULL THEN 0
		 ELSE SUM(credit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(debit) is null then 0
		 ELSE SUM(debit)
		 END)) INTO varDeferLiaPY
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "DL"
	  AND YEAR(je.entry_date) = (varCalendarYear - 1);

	SELECT 
		((CASE 
		 WHEN SUM(credit) IS NULL THEN 0
		 ELSE SUM(credit) 
		 END)
		 -
		 (CASE 
		 WHEN SUM(debit) is null then 0
		 ELSE SUM(debit)
		 END)) INTO varTotalEquityPY
	FROM journal_entry AS je
	INNER JOIN journal_entry_line_item AS jeli 
			ON je.journal_entry_id = jeli.journal_entry_id
	INNER JOIN `account` AS ac 
			ON ac.account_id = jeli.account_id
	INNER JOIN statement_section AS ss 
			ON ss.statement_section_id = ac.balance_sheet_section_id
	WHERE ss.statement_section_code = "EQ"
	  AND YEAR(je.entry_date) = (varCalendarYear - 1);


-- Part 3: time to use our temporary table available, here we design the balance sheet, both visualy and with the needed formula.
-- we have 4 columns in our data so we need to 

	DROP TABLE IF EXISTS H_Accounting.jcarrillo_tmp;
	CREATE TABLE H_Accounting.jcarrillo_tmp
	(N_line INT, Title VARCHAR(50), Amount VARCHAR(50), Change_years VARCHAR(50));

	-- Start by creating the first row like title (Visual Part)

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES (1, 'BALANCE SHEET', "In Thousands USD", "% Change");

	INSERT INTO H_Accounting.jcarrillo_tmp -- This line is just spacer
	(N_line, Title, Amount, Change_years)
	VALUES  (2, '', '', '');

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (3, 'Total Current Assets', format(varCurrentAss / 1000, 2), format(ifnull((varCurrentAss - varCurrentAssPY)/NULLIF(varCurrentAss,0)*100,0),2));

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (4, 'Total Fixed Assets', format(varFixedAss / 1000, 2), format(ifnull((varFixedAss - varFixedAssPY)/NULLIF(varFixedAssPY,0)*100,0),2));

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (5, 'Total Deferred Assets', format(varDeferredAss / 1000, 2), format(ifnull((varDeferredAss - varDeferredAssPY)/NULLIF(varDeferredAssPY,0)*100,0),2));

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (5, 'Total Assets', format((varDeferredAss + varCurrentAss + varFixedAss) / 1000, 2),format((varCurrentAss - varCurrentAssPY)/NULLIF(varCurrentAssPY,0)*100,2));

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (6, '', '', '');

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (7, 'Total Current Liabilities', format(varCurrentLia / 1000, 2), format(ifnull((varCurrentLia - varCurrentLiaPY)/NULLIF(varCurrentLiaPY,0)*100,0),2));

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (8, 'Total Long-Term Liabilities', format(varLongTermLia / 1000, 2), format(ifnull((varLongTermLia - varLongTermLiaPY)/NULLIF(varLongTermLiaPY,0)*100,0),2));

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (9, 'Total Deferred Liabilities', format(varDeferLia / 1000, 2), format(ifnull((varDeferLia - varDeferLiaPY)/NULLIF(varDeferLiaPY,0)*100,0),2));

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (10, 'Total Liabilities', format((varCurrentLia + varLongTermLia + varDeferLia) / 1000, 2),format(((varCurrentLia + varLongTermLia + varDeferLia)-(varCurrentLiaPY + varLongTermLiaPY + varDeferLiaPY)) / (varCurrentLiaPY + varLongTermLiaPY + varDeferLiaPY) * 100, 2));

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (11, '', '', '');

	INSERT INTO H_Accounting.jcarrillo_tmp
	(N_line, Title, Amount, Change_years)
	VALUES  (12, 'Total Equity', format(varTotalEquity / 1000, 2),format((NULLIF(varTotalEquity,0) - NULLIF(varTotalEquityPY,0))/NULLIF(varTotalEquityPY,0)*100,2));

END $$
DELIMITER ; -- With this we tell SQL we are going back to using the ; in our code as delimiter

-- Time to call the function, here we will need to input the year of the bs we want to SEE. 
CALL H_Accounting.newtestBS(2016);

-- Then selecting your temporary table to view the balance sheet.
SELECT * FROM H_Accounting.jcarrillo_tmp;