--========================================================--
--                Scorpion Framework Core System          --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2025/03/21                              --
--========================================================--

--========================================================--
Scorpio           "Scorpion"        	     			  ""
--========================================================--

namespace "Scorpion"

-----------------------------------------------------------
-- File System
-----------------------------------------------------------
__Sealed__() __Serializable__()
class "File"							(function(_ENV)

	-------------------------------------------------------
	--                     Property                      --
	-------------------------------------------------------
	--- File name
	property "Name" 					{ type = String }

	--- Type
	property "Type" 					{ type = String }

	--- Raw content
	property "RawContent" 				{ type = String }

	--- Content
	__NonSerialized__()
	property "Content" 					{
		type 							= String,
		default 						= function(self)
			return Scorpio.DeflateDecode(Scorpio.Base64Decode(self.RawContent))
		end,
		handler 						= function(self, new)
			Continue(function(self, new)
				self.RawContent 		= Scorpio.Base64Encode(Scorpio.DeflateEncode(new))
			end, self, new)
		end,
	}

	__NonSerialized__()
	property "Node" 					{
		set 							= false,
		default 						= function(self)
			local cls 					= __FileNode__.GetFileNodeClass(self.Type)
			if not cls then return end

			local obj 					= cls()
			Scorpio.Next(function()
				local content 			= Scorpio.DeflateDecode(Scorpio.Base64Decode(self.RawContent))
				return obj:Load(content)
			end)
			return obj
		end
	}

	-------------------------------------------------------
	--                      Method                       --
	-------------------------------------------------------
	function Save(self)
		self.Content 					= self.Node:Dump()
	end

	-------------------------------------------------------
	--                    Meta-Method                    --
	-------------------------------------------------------
	function __dtor(self)
		return self.Node:Dispose()
	end
end)

--- Folders
__Sealed__() __Serializable__()
class "Folder" 							(function(_ENV)
	--- Folder name
	property "Name" 					{ type = String }

	--- Sub folders
	property "Folders" 					{ type = struct { Folder } }

	--- Sub files
	property "Files" 					{ type = struct { File } }
end)

-----------------------------------------------------------
-- File Node
-----------------------------------------------------------
__Sealed__()
class "__FileNode__" 					(function(_ENV)
	extend "IAttachAttribute"

	_TypeMap 						= {}

	-------------------------------------------------------
	--                   Static Method                   --
	-------------------------------------------------------
	__Static__()
	function GetFileNodeClass(type)
		return _TypeMap[type]
	end

	-------------------------------------------------------
	--                      Method                       --
	-------------------------------------------------------
	function AttachAttribute(self, target, targettype, owner, name, stack)
		for i = 1, #self do
			_TypeMap[self[i]] 		= target
		end
	end

	-------------------------------------------------------
	--                     Property                      --
	-------------------------------------------------------
	property "AttributeTarget" { default = AttributeTargets.Class }

	-------------------------------------------------------
	--                    Constrctor                     --
	-------------------------------------------------------
	__Arguments__{ NEString * 1}
	function __new(_, ...)
		return { ... }, true
	end
end)

__Sealed__()
interface "IFileNode" 					(function(_ENV)
	-------------------------------------------------------
	--                     Property                      --
	-------------------------------------------------------

	--- The file ref
	__Abstract__()
	property "File" 					{ type = File }

	-------------------------------------------------------
	--                      Method                       --
	-------------------------------------------------------

	--- Dump to the file content
	__Abstract__()
	function Dump(self) end

	--- Load the file content
	__Abstract__()
	function Load(self, content) end

	-------------------------------------------------------
	--                    Meta-Method                    --
	-------------------------------------------------------
	function __dtor(self) end
end)