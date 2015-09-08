import {Statement,ManipulativeStatement} from '../index';
import {TableRef,ParameterRef} from '../common/ref';
import {SelectQuery, JoinRef} from '../query/select';
import {OrderBy} from '../query/orderby';
import {Assignment} from '../query/update';

export class CursorDefinitionStatement extends Statement {
	name:string;
	select:SelectQuery;
	orderBy:Array<OrderBy>;	
}

export class DeleteCursorQuery extends ManipulativeStatement {
	from:TableRef;
	cursor:string;
}

export class UpdateCursorQuery extends ManipulativeStatement {
	table:TableRef;
	joins:Array<JoinRef>;
	assignments:Array<Assignment>;
	cursor:string;
}


export class Fetch extends ManipulativeStatement {
	cursor:string;
	parameters:Array<ParameterRef>;
}

export class Open extends ManipulativeStatement {
	cursor:string;
}

export class Close extends ManipulativeStatement {
	cursor:string;
}
