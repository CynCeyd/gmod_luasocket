newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://github.com/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common directory"
})

local gmcommon = assert(_OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON"),
	"you didn't provide a path to your garrysmod_common (https://github.com/danielga/garrysmod_common) directory")
include(path.join(gmcommon, "generator.v2.lua"))

newoption({
	trigger = "enable-whitelist",
	description = "Enables a whitelist file to filter valid addresses and ports"
})

local LUASOCKET_FOLDER = "luasocket/src"

CreateWorkspace({name = "socket.core"})
	CreateProject({serverside = true, manual_files = true})
		files("source/socket.cpp")
		IncludeLuaShared()
		includedirs(LUASOCKET_FOLDER)
		links("socket")

		filter("options:enable-whitelist")
			defines("ENABLE_WHITELIST")

		filter("system:windows")
			links("ws2_32")

	CreateProject({serverside = false, manual_files = true})
		files("source/socket.cpp")
		IncludeLuaShared()
		includedirs(LUASOCKET_FOLDER)
		links("socket")

		filter("options:enable-whitelist")
			defines("ENABLE_WHITELIST")

		filter("system:windows")
			links("ws2_32")

	project("socket")
		kind("StaticLib")
		includedirs(LUASOCKET_FOLDER)
		files({
			LUASOCKET_FOLDER .. "/auxiliar.c",
			LUASOCKET_FOLDER .. "/auxiliar.h",
			LUASOCKET_FOLDER .. "/buffer.c",
			LUASOCKET_FOLDER .. "/buffer.h",
			LUASOCKET_FOLDER .. "/compat.c",
			LUASOCKET_FOLDER .. "/compat.h",
			LUASOCKET_FOLDER .. "/except.c",
			LUASOCKET_FOLDER .. "/except.h",
			LUASOCKET_FOLDER .. "/filter.h",
			LUASOCKET_FOLDER .. "/inet.c",
			LUASOCKET_FOLDER .. "/inet.h",
			LUASOCKET_FOLDER .. "/io.c",
			LUASOCKET_FOLDER .. "/io.h",
			LUASOCKET_FOLDER .. "/luasocket.c",
			LUASOCKET_FOLDER .. "/luasocket.h",
			LUASOCKET_FOLDER .. "/options.c",
			LUASOCKET_FOLDER .. "/options.h",
			LUASOCKET_FOLDER .. "/pierror.h",
			LUASOCKET_FOLDER .. "/select.c",
			LUASOCKET_FOLDER .. "/select.h",
			LUASOCKET_FOLDER .. "/tcp.c",
			LUASOCKET_FOLDER .. "/tcp.h",
			LUASOCKET_FOLDER .. "/timeout.c",
			LUASOCKET_FOLDER .. "/timeout.h",
			LUASOCKET_FOLDER .. "/udp.c",
			LUASOCKET_FOLDER .. "/udp.h"
		})
		vpaths({
			["Source files/*"] = LUASOCKET_FOLDER .. "/*.c",
			["Header files/*"] = LUASOCKET_FOLDER .. "/*.h"
		})
		IncludeLuaShared()

		filter("options:enable-whitelist")
			defines("LUASOCKET_ENABLE_WHITELIST")

		filter("system:windows")
			defines({
				"LUASOCKET_API=__declspec(dllexport)",
				"_WINSOCK_DEPRECATED_NO_WARNINGS"
			})
			files({
				LUASOCKET_FOLDER .. "/wsocket.c",
				LUASOCKET_FOLDER .. "/wsocket.h"
			})
			links("ws2_32")

		filter("system:not windows")
			defines("LUASOCKET_API=''")
			files({
				LUASOCKET_FOLDER .. "/usocket.c",
				LUASOCKET_FOLDER .. "/usocket.h"
			})

CreateWorkspace({name = "mime.core"})
	CreateProject({serverside = true, manual_files = true})
		files("source/mime.cpp")
		IncludeLuaShared()
		links("mime")

	CreateProject({serverside = false, manual_files = true})
		files("source/mime.cpp")
		IncludeLuaShared()
		links("mime")

	project("mime")
		kind("StaticLib")
		includedirs(LUASOCKET_FOLDER)
		files({
			LUASOCKET_FOLDER .. "/compat.c",
			LUASOCKET_FOLDER .. "/compat.h",
			LUASOCKET_FOLDER .. "/mime.c",
			LUASOCKET_FOLDER .. "/mime.h"
		})
		vpaths({
			["Source files/*"] = LUASOCKET_FOLDER .. "/*.c",
			["Header files/*"] = LUASOCKET_FOLDER .. "/*.h"
		})
		IncludeLuaShared()

		filter("system:windows")
			defines("LUASOCKET_API=__declspec(dllexport)")

		filter("system:not windows")
			defines("LUASOCKET_API=''")

if os.istarget("linux") or os.istarget("macosx") then
	CreateWorkspace({name = "socket.unix"})
		CreateProject({serverside = true, manual_files = true})
			files("source/unix.cpp")
			IncludeLuaShared()
			links("unix")

		CreateProject({serverside = false, manual_files = true})
			files("source/unix.cpp")
			IncludeLuaShared()
			links("unix")

		project("unix")
			kind("StaticLib")
			defines("LUASOCKET_API=''")
			includedirs(LUASOCKET_FOLDER)
			files({
				LUASOCKET_FOLDER .. "/auxiliar.c",
				LUASOCKET_FOLDER .. "/auxiliar.h",
				LUASOCKET_FOLDER .. "/buffer.c",
				LUASOCKET_FOLDER .. "/buffer.h",
				LUASOCKET_FOLDER .. "/compat.c",
				LUASOCKET_FOLDER .. "/compat.h",
				LUASOCKET_FOLDER .. "/io.c",
				LUASOCKET_FOLDER .. "/io.h",
				LUASOCKET_FOLDER .. "/options.c",
				LUASOCKET_FOLDER .. "/options.h",
				LUASOCKET_FOLDER .. "/pierror.h",
				LUASOCKET_FOLDER .. "/timeout.c",
				LUASOCKET_FOLDER .. "/timeout.h",
				LUASOCKET_FOLDER .. "/unix.c",
				LUASOCKET_FOLDER .. "/unix.h",
				LUASOCKET_FOLDER .. "/unixdgram.c",
				LUASOCKET_FOLDER .. "/unixdgram.h",
				LUASOCKET_FOLDER .. "/unixstream.c",
				LUASOCKET_FOLDER .. "/unixstream.h",
				LUASOCKET_FOLDER .. "/usocket.c",
				LUASOCKET_FOLDER .. "/usocket.h"
			})
			vpaths({
				["Source files/*"] = LUASOCKET_FOLDER .. "/*.c",
				["Header files/*"] = LUASOCKET_FOLDER .. "/*.h"
			})
			IncludeLuaShared()

	CreateWorkspace({name = "socket.serial"})
		CreateProject({serverside = true, manual_files = true})
			files("source/serial.cpp")
			IncludeLuaShared()
			links("serial")

		CreateProject({serverside = false, manual_files = true})
			files("source/serial.cpp")
			IncludeLuaShared()
			links("serial")

		project("serial")
			kind("StaticLib")
			defines("LUASOCKET_API=''")
			includedirs(LUASOCKET_FOLDER .. "/src")
			files({
				LUASOCKET_FOLDER .. "/auxiliar.c",
				LUASOCKET_FOLDER .. "/auxiliar.h",
				LUASOCKET_FOLDER .. "/buffer.c",
				LUASOCKET_FOLDER .. "/buffer.h",
				LUASOCKET_FOLDER .. "/compat.c",
				LUASOCKET_FOLDER .. "/compat.h",
				LUASOCKET_FOLDER .. "/io.c",
				LUASOCKET_FOLDER .. "/io.h",
				LUASOCKET_FOLDER .. "/options.c",
				LUASOCKET_FOLDER .. "/options.h",
				LUASOCKET_FOLDER .. "/pierror.h",
				LUASOCKET_FOLDER .. "/timeout.c",
				LUASOCKET_FOLDER .. "/timeout.h",
				LUASOCKET_FOLDER .. "/usocket.c",
				LUASOCKET_FOLDER .. "/usocket.h",
				LUASOCKET_FOLDER .. "/serial.c"
			})
			vpaths({
				["Source files/*"] = LUASOCKET_FOLDER .. "/*.c",
				["Header files/*"] = LUASOCKET_FOLDER .. "/*.h"
			})
			IncludeLuaShared()
end
