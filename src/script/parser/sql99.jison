%lex

%%
"ALL"                                 return 'ALL';
"AND"                                 return 'AND';
"AVG"                                 return 'AVG';
"MIN"                                 return 'MIN';
"MAX"                                 return 'MAX';
"SUM"                                 return 'SUM';
"COUNT"                               return 'COUNT';
"ANY"                                 return 'ANY';
"AS"                                  return 'AS';
"ASC"                                 return 'ASC';
"AUTHORIZATION"                       return 'AUTHORIZATION';
"BETWEEN"                             return 'BETWEEN';
"BY"                                  return 'BY';
CHAR(ACTER)?                          return 'CHARACTER';
"CHECK"                               return 'CHECK';
"CLOSE"                               return 'CLOSE';
"COMMIT"                              return 'COMMIT';
"CONTINUE"                            return 'CONTINUE';
"CREATE"                              return 'CREATE';
"CURRENT"                             return 'CURRENT';
"CURSOR"                              return 'CURSOR';
"DECIMAL"                             return 'DECIMAL';
"DECLARE"                             return 'DECLARE';
"DEFAULT"                             return 'DEFAULT';
"DELETE"                              return 'DELETE';
"DESC"                                return 'DESC';
"DISTINCT"                            return 'DISTINCT';
"DOUBLE"                              return 'DOUBLE';
"ESCAPE"                              return 'ESCAPE';
"EXISTS"                              return 'EXISTS';
"FETCH"                               return 'FETCH';
"FLOAT"                               return 'FLOAT';
"FOR"                                 return 'FOR';
"FOREIGN"                             return 'FOREIGN';
"FOUND"                               return 'FOUND';
"FROM"                                return 'FROM';
"FULL"                                return 'FULL';
GO[ \t]TO                             return 'GOTO';
"GRANT"                               return 'GRANT';
"GROUP"                               return 'GROUP';
"HAVING"                              return 'HAVING';
"IN"                                  return 'IN';
"INDICATOR"                           return 'INDICATOR';
"INNER"                               return 'INNER';
"INSERT"                              return 'INSERT';
INT(EGER)?                            return 'INTEGER';
"INTO"                                return 'INTO';
"IS"                                  return 'IS';
"JOIN"                                return 'JOIN';
"KEY"                                 return 'KEY';
"LANGUAGE"                            return 'LANGUAGE';
"LIKE"                                return 'LIKE';
"LEFT"                                return 'LEFT';
"NOT"                                 return 'NOT';
"NULL"                                return 'NULLX';
"NUMERIC"                             return 'NUMERIC';
"OF"                                  return 'OF';
"ON"                                  return 'ON';
"OPEN"                                return 'OPEN';
"OPTION"                              return 'OPTION';
"OR"                                  return 'OR';
"ORDER"                               return 'ORDER';
"OUTER"                               return 'OUTER';
"PRECISION"                           return 'PRECISION';
"PRIMARY"                             return 'PRIMARY';
"PRIVILEGES"                          return 'PRIVILEGES';
"PROCEDURE"                           return 'PROCEDURE';
"PUBLIC"                              return 'PUBLIC';
"REAL"                                return 'REAL';
"REFERENCES"                          return 'REFERENCES';
"RIGHT"                               return 'RIGHT';
"ROLLBACK"                            return 'ROLLBACK';
"SCHEMA"                              return 'SCHEMA';
"SELECT"                              return 'SELECT';
"SET"                                 return 'SET';
"SMALLINT"                            return 'SMALLINT';
"SOME"                                return 'SOME';
"SQLCODE"                             return 'SQLCODE';
"TABLE"                               return 'TABLE';
"TO"                                  return 'TO';
"UNION"                               return 'UNION';
"UPDATE"                              return 'UPDATE';
"USER"                                return 'USER';
"VALUES"                              return 'VALUES';
"VIEW"                                return 'VIEW';
"WHENEVER"                            return 'WHENEVER';
"WHERE"                               return 'WHERE';
"WITH"                                return 'WITH';
"WORK"                                return 'WORK';

\'[^'\n]*\'                           return 'STRING_LITERAL';
\d+|\.\d+|\d\.\d*                     return 'NUMBER_LITERAL';
\d+[eE][+-]?\d+|\d\.\d*[eE][+-]?\d+|\.\d*[eE][+-]?\d+ return 'SCIENTIFIC_NUMBER_LITERAL';

[A-Za-z][A-Za-z0-9_.]*                {
	if (yytext.match(/^(ABS|AVG|MIN|MAX|SUM|COUNT|FLOOR|LOWER|UPPER)$/i)) {
		return 'BUILTIN_FUNCTION';
	} else {
		return 'IDENTIFIER';
	}
}

"--.*"                                return 'COMMENT';

:[A-Za-z][A-Za-z0-9_]*				  return PARAMETER;

'"'                                   return 'DOUBLE_QUOTE';
"%"                                   return 'PERCENT';
"&"                                   return 'AMPERSAND';
"'"                                   return 'QUOTE';
"("                                   return 'LEFT_PAREN';
")"                                   return 'RIGHT_PAREN';
"."                                   return 'PERIOD';
":"                                   return 'COLON';
","                                   return 'COMMA';
";"                                   return 'SEMICOLON';
"|"                                   return 'VERTICAL_BAR';
"?"                                   return 'QUESTION_MARK';
"^"                                   return 'CARET';

"*"                                   return 'ASTERISK';
"/"                                   return 'DIVIDE';
"+"                                   return 'PLUS';
"-"                                   return 'MINUS';
"="                                   return 'EQUAL';
"<>"                                  return 'NOT_EQUAL';
"<"                                   return 'LESS_THAN';
">"                                   return 'GREATER_THAN';
"<="                                  return 'LESS_THAN_OR_EQUAL';
">="                                  return 'GREATER_THAN_OR_EQUAL';

[ \r\t]+                              /* Skip */;

<<EOF>>                               return 'EOF';

/lex

%left OR
%left AND
%left NOT
%left EQUAL NOT_EQUAL LESS_THAN GREATER_THAN LESS_THAN_OR_EQUAL GREATER_THAN_OR_EQUAL
%left PLUS MINUS
%left ASTERISK DIVIDE
%nonassoc UMINUS

%start program

%{
	console.log("Starting");
%}

%%

program: stmt_list
    ;

stmt_list:
		stmt SEMICOLON
    |   stmt SEMICOLON EOF
    |   stmt     EOF
	|	stmt_list stmt SEMICOLON
	;


	/* the various things you can name */
literal:
		STRING_LITERAL
	|	NUMBER_LITERAL
	|	SCIENTIFIC_NUMBER_LITERAL
	;	
	
column:		IDENTIFIER
	;

cursor:		IDENTIFIER
	;

parameter:
		PARAMETER	/* :name handled in parser */
	;

range_variable:	IDENTIFIER
	;

userName:		IDENTIFIER
	;
	
alias:		IDENTIFIER
	;

		/* data types */

data_type:
		CHARACTER
	|	CHARACTER LEFT_PAREN NUMBER_LITERAL RIGHT_PAREN
	|	NUMERIC
	|	NUMERIC LEFT_PAREN NUMBER_LITERAL RIGHT_PAREN
	|	NUMERIC LEFT_PAREN NUMBER_LITERAL COMMA NUMBER_LITERAL RIGHT_PAREN
	|	DECIMAL
	|	DECIMAL LEFT_PAREN NUMBER_LITERAL RIGHT_PAREN
	|	DECIMAL LEFT_PAREN NUMBER_LITERAL COMMA NUMBER_LITERAL RIGHT_PAREN
	|	INTEGER
	|	SMALLINT
	|	FLOAT
	|	FLOAT LEFT_PAREN NUMBER_LITERAL RIGHT_PAREN
	|	REAL
	|	DOUBLE PRECISION
	;

	/* search conditions */

search_condition:
	|	search_condition OR search_condition
	|	search_condition AND search_condition
	|	NOT search_condition
	|	LEFT_PAREN search_condition RIGHT_PAREN
	|	predicate
	;

predicate:
		comparison_predicate
	|	between_predicate
	|	like_predicate
	|	test_for_null
	|	in_predicate
	|	all_or_any_predicate
	|	existence_test
	;

comparison:
    EQUAL
    | NOT_EQUAL
    | LESS_THAN
    | GREATER_THAN
    | LESS_THAN_EQUAL
    | GREATER_THAN_EQUAL
    ;

comparison_predicate:
		scalar_exp comparison scalar_exp
	|	scalar_exp comparison subquery
	;

between_predicate:
		scalar_exp NOT BETWEEN scalar_exp AND scalar_exp
	|	scalar_exp BETWEEN scalar_exp AND scalar_exp
	;

like_predicate:
		scalar_exp NOT LIKE STRING_LITERAL opt_escape
	|	scalar_exp LIKE STRING_LITERAL opt_escape
	;

opt_escape:
		/* empty */
	|	ESCAPE STRING_LITERAL
	;

test_for_null:
		column_ref IS NOT NULLX
	|	column_ref IS NULLX
	;

in_predicate:
		scalar_exp NOT IN LEFT_PAREN subquery RIGHT_PAREN
	|	scalar_exp IN LEFT_PAREN subquery RIGHT_PAREN
	|	scalar_exp NOT IN LEFT_PAREN atom_commalist RIGHT_PAREN
	|	scalar_exp IN LEFT_PAREN atom_commalist RIGHT_PAREN
	;

atom_commalist:
		atom
	|	atom_commalist COMMA atom
	;

all_or_any_predicate:
		scalar_exp comparison any_all_some subquery
	;

any_all_some:
		ANY
	|	ALL
	|	SOME
	;

existence_test:
		EXISTS subquery
	;

subquery:
		LEFT_PAREN select_inner_statement RIGHT_PAREN
	;

	/* scalar expressions */

scalar_exp:
		scalar_exp PLUS scalar_exp
	|	scalar_exp MINUS scalar_exp
	|	scalar_exp ASTERISK scalar_exp
	|	scalar_exp DIVIDE scalar_exp
	|	PLUS scalar_exp %prec UMINUS
	|	MINUS scalar_exp %prec UMINUS
	|	atom
	|	column_ref
	|	function_ref
	|	LEFT_PAREN scalar_exp RIGHT_PAREN
	;
	
selection_scalar:
		scalar_exp
	|	scalar_exp alias
	|	scalar_exp AS alias
	;

selection_commalist:
		selection_scalar
	|	selection_commalist COMMA selection_scalar
	;

atom:
		parameter_ref
	|	literal
	|	USER
	;

parameter_ref:
		parameter
	|	parameter parameter
	|	parameter INDICATOR parameter
	;

function_ref:
		BUILTIN_FUNCTION LEFT_PAREN ASTERISK RIGHT_PAREN
	|	BUILTIN_FUNCTION LEFT_PAREN DISTINCT column_ref RIGHT_PAREN
	|	BUILTIN_FUNCTION LEFT_PAREN ALL scalar_exp RIGHT_PAREN
	|	BUILTIN_FUNCTION LEFT_PAREN scalar_exp RIGHT_PAREN
	;


	/* miscellaneous */

table:
		IDENTIFIER
	|	IDENTIFIER PERIOD IDENTIFIER
	;

column_ref:
		IDENTIFIER
	|	IDENTIFIER PERIOD IDENTIFIER	/* needs semantics */
	|	IDENTIFIER PERIOD IDENTIFIER PERIOD IDENTIFIER
	;

	/* schema definition language */
stmt:		schema
	;

schema:
		CREATE SCHEMA AUTHORIZATION userName opt_schema_element_list
	;

opt_schema_element_list:
		/* empty */
	|	schema_element_list
	;

schema_element_list:
		schema_element
	|	schema_element_list schema_element
	;

schema_element:
		base_table_def
	|	view_def
	|	privilege_def
	;

base_table_def:
		CREATE TABLE table LEFT_PAREN base_table_element_commalist RIGHT_PAREN
	;

base_table_element_commalist:
		base_table_element
	|	base_table_element_commalist COMMA base_table_element
	;

base_table_element:
		column_def
	|	table_constraint_def
	;

column_def:
		column data_type column_def_opt_list
	;

column_def_opt_list:
		/* empty */
	|	column_def_opt_list column_def_opt
	;

column_def_opt:
		NOT NULLX
	|	NOT NULLX UNIQUE
	|	NOT NULLX PRIMARY KEY
	|	DEFAULT literal
	|	DEFAULT NULLX
	|	DEFAULT USER
	|	CHECK LEFT_PAREN search_condition RIGHT_PAREN
	|	REFERENCES table
	|	REFERENCES table LEFT_PAREN column_commalist RIGHT_PAREN
	;

table_constraint_def:
		UNIQUE LEFT_PAREN column_commalist RIGHT_PAREN
	|	PRIMARY KEY LEFT_PAREN column_commalist RIGHT_PAREN
	|	FOREIGN KEY LEFT_PAREN column_commalist RIGHT_PAREN
			REFERENCES table
	|	FOREIGN KEY LEFT_PAREN column_commalist RIGHT_PAREN
			REFERENCES table LEFT_PAREN column_commalist RIGHT_PAREN
	|	CHECK LEFT_PAREN search_condition RIGHT_PAREN
	;

column_commalist:
		column
	|	column_commalist COMMA column
	;

view_def:
		CREATE VIEW table opt_column_commalist
		AS select_inner_statement opt_with_check_option
	;

opt_with_check_option:
		/* empty */
	|	WITH CHECK OPTION
	;

opt_column_commalist:
		/* empty */
	|	LEFT_PAREN column_commalist RIGHT_PAREN
	;

privilege_def:
		GRANT privileges ON table TO grantee_commalist
		opt_with_grant_option
	;

opt_with_grant_option:
		/* empty */
	|	WITH GRANT OPTION
	;

privileges:
		ALL PRIVILEGES
	|	ALL
	|	operation_commalist
	;

operation_commalist:
		operation
	|	operation_commalist COMMA operation
	;

operation:
		SELECT
	|	INSERT
	|	DELETE
	|	UPDATE opt_column_commalist
	|	REFERENCES opt_column_commalist
	;


grantee_commalist:
		grantee
	|	grantee_commalist COMMA grantee
	;

grantee:
		PUBLIC
	|	userName
	;

	/* cursor definition */
stmt:
		cursor_def
	;


cursor_def:
		DECLARE cursor CURSOR FOR query_exp
	;

	/* manipulative statements */

stmt:		manipulative_statement
	;

manipulative_statement:
		close_statement
	|	commit_statement
	|	delete_statement_positioned
	|	delete_statement_searched
	|	fetch_statement
	|	insert_statement
	|	open_statement
	|	rollback_statement
	|	select_statement
	|	update_statement_positioned
	|	update_statement_searched
	;

close_statement:
		CLOSE cursor
	;

commit_statement:
		COMMIT WORK
	|	COMMIT
	;

delete_statement_positioned:
		DELETE FROM table_ref opt_join_ref_list WHERE CURRENT OF cursor
	;

delete_statement_searched:
		DELETE FROM table_ref opt_join_ref_list opt_where_clause
	;

fetch_statement:
		FETCH cursor INTO target_commalist
	;

insert_statement:
		INSERT INTO table opt_column_commalist values_or_query_spec
	;

values_or_query_spec:
		VALUES LEFT_PAREN insert_atom_commalist RIGHT_PAREN
	|	select_inner_statement
	;

insert_atom_commalist:
		insert_atom
	|	insert_atom_commalist COMMA insert_atom
	;

insert_atom:
		atom
	|	NULLX
	;

open_statement:
		OPEN cursor
	;

rollback_statement:
		ROLLBACK WORK
	|	ROLLBACK
	;

opt_into_clause:
    INTO target_commalist
    | ;

select_statement:
    SELECT opt_all_distinct selection
    opt_into_clause
    table_exp
    ;

select_read_only_statement:
    SELECT opt_all_distinct selection
    table_exp
    ;

select_inner_statement:
    SELECT opt_all_distinct selection
    table_exp_inner
    ;

opt_all_distinct:
		/* empty */
	|	ALL
	|	DISTINCT
	;

update_statement_positioned:
		UPDATE table SET assignment_commalist
		WHERE CURRENT OF cursor
	;

assignment_commalist:
	|	assignment
	|	assignment_commalist COMMA assignment
	;

assignment:
		column EQUAL scalar_exp
	|	column EQUAL NULLX
	;

update_statement_searched:
		UPDATE table SET assignment_commalist opt_where_clause
	;

target_commalist:
		target
	|	target_commalist COMMA target
	;

target:
		parameter_ref
	;

opt_where_clause:
		/* empty */
	|	where_clause
	;

	/* query expressions */

query_exp:
		query_term
	|	query_exp UNION query_term
	|	query_exp UNION ALL query_term
	;

query_term:
		select_read_only_statement
	|	LEFT_PAREN query_exp RIGHT_PAREN
	;

selection:
		selection_commalist
	|	ASTERISK
	;

table_exp:
		table_exp_inner
		opt_order_by_clause
	;
	
table_exp_inner:
		from_clause
		opt_where_clause
		opt_group_by_clause
		opt_having_clause
	;

from_clause:
		FROM dynamic_table_ref_commalist
		opt_join_ref_list
	;

opt_join_outer:
		/* empty */
	|	OUTER
	;

join_type:
		LEFT opt_join_outer
	|	RIGHT opt_join_outer
	|	FULL opt_join_outer
	|	INNER						
	;
	
opt_join_on_clause:
		/* empty */
	|	ON search_condition
	;

join_ref:
	join_type JOIN dynamic_table_ref opt_join_on_clause
	;

join_ref_list:
		join_ref
	|	join_ref_list join_ref
	;
	
opt_join_ref_list:
		/* empty */
	|	join_ref_list
	;
	
dynamic_table_ref_commalist:
		dynamic_table_ref
	|	dynamic_table_ref_commalist COMMA dynamic_table_ref
	;
	
opt_as:
		/* empty */
	| AS
	;
	
opt_range:
		/* empty */
	|	range_variable
	;

table_ref:
		table opt_as opt_range
	;

dynamic_table_ref:
		table_ref
	|   LEFT_PAREN select_inner_statement RIGHT_PAREN opt_as opt_range;


where_clause:
		WHERE search_condition
	;

opt_group_by_clause:
		/* empty */
	|	GROUP BY column_ref_commalist
	;

column_ref_commalist:
		column_ref
	|	column_ref_commalist COMMA column_ref
	;

opt_having_clause:
		/* empty */
	|	HAVING search_condition
	;

opt_order_by_clause:
		/* empty */
	|	ORDER BY ordering_spec_commalist
	;

ordering_spec_commalist:
		ordering_spec
	|	ordering_spec_commalist COMMA ordering_spec
	;

ordering_spec:
		NUMBER_LITERAL opt_asc_desc
	|	column_ref opt_asc_desc
	;

opt_asc_desc:
		/* empty */
	|	ASC
	|	DESC
	;

	/* embedded condition things */
stmt:		
		WHENEVER NOT FOUND when_action
	|	WHENEVER SQLERROR when_action
	;

when_action:	
		GOTO IDENTIFIER
	|	CONTINUE
	;