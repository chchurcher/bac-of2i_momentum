function obj = init( obj, w_0, varargin )
%  INIT - Initialize laguerre gauss object.
%
%  Usage for obj = laguerre gauss :
%    obj = init( obj, w_0, varargin )
%  Input
%    w_0    :  beam waist

%  set up parser
p = inputParser;
p.KeepUnmatched = true;
addParameter( p, 'rules', quadboundary.rules );
addParameter( p, 'imat', 1 );
%  parse input
parse( p, varargin{ : } );

%  beam waist of laguerre gauss beam
obj.w_0 = w_0;
%  integration rules and index for embedding medium
obj.rules = p.Results.rules;
obj.imat  = p.Results.imat;
 
