#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_socket_serial( lua_State *state );

GMOD_MODULE_OPEN( )
{
	LUA->GetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );

	if( luaopen_socket_serial( state ) == 1 )
	{
		lua_replace( state, 1 );
		lua_settop( state, 1 );
		LUA->Push( -1 );
		LUA->SetField( -3, "serial" );
	}

	return 1;
}

GMOD_MODULE_CLOSE( )
{
	LUA->GetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );

	LUA->PushNil( );
	LUA->SetField( -2, "serial" );

	LUA->Pop( 1 );
	return 0;
}
