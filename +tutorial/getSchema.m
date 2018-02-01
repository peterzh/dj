function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'tutorial', 'tutorial_db');
end
obj = schemaObject;
end
