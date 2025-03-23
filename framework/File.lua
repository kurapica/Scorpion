--========================================================--
--                Scorpion Framework File System          --
--                                                        --
-- Author      :  kurapica125@outlook.com                 --
-- Create Date :  2025/03/21                              --
--========================================================--

--========================================================--
Scorpio           "Scorpion"                              ""
--========================================================--

-----------------------------------------------------------
-- File System
-----------------------------------------------------------
__Sealed__()
class "File"                            (function(_ENV)

    -------------------------------------------------------
    --                     Property                      --
    -------------------------------------------------------
    --- File name
    __Abstract__()
    property "Name"                     { type = String }

    --- Raw content
    property "RawContent"               { type = String }

    --- Content
    property "Content"                  {
        type                            = String,
        default                         = function(self)
            return Scorpio.DeflateDecode(Scorpio.Base64Decode(self.RawContent))
        end,
        handler                         = function(self, new)
            Continue(function(self, new)
                self.RawContent         = Scorpio.Base64Encode(Scorpio.DeflateEncode(new))
            end, self, new)
        end,
    }

    -------------------------------------------------------
    --                      Method                       --
    -------------------------------------------------------
    --- Save the file to content
    function Save(self)
        self.RawContent                 = Scorpio.Base64Encode(Scorpio.DeflateEncode(self:Dump()))
    end

    --- Dump the file to a string
    __Abstract__()
    function Dump(self) return "" end

    --- Load the file from content
    __Abstract__()
    function Load(self, content) end

    -------------------------------------------------------
    --                    Initialize                     --
    -------------------------------------------------------
    function __init(self)
        return self:Load(self.Content)
    end
end)

--- Folders
__Sealed__()
class "Folder"                          (function(_ENV)
    --- Folder name
    property "Name"                     { type = String }

    --- Sub folders
    property "Folders"                  { type = List[Folder], default = function() return List[Folder]() end }

    --- Sub files
    property "Files"                    { type = List[File], default = function() return List[File]() end }
end)

--- Mark the file node type
__Sealed__()
class "__FileType__"                    (function(_ENV)
    extend "IAttachAttribute"

    _TypeMap                            = {}

    -------------------------------------------------------
    --                   Static Method                   --
    -------------------------------------------------------
    __Static__()
    function GetFileType(type)          return _TypeMap[type] end

    __Static__()
    __Iterator__()
    function GetFileTypes()
        local yield                     = coroutine.yield
        local i                         = 1
        for k in pairs(_TypeMap) do
            yield(i, k)
            i                           = i + 1
        end
    end

    -------------------------------------------------------
    --                      Method                       --
    -------------------------------------------------------
    function AttachAttribute(self, target, targettype, owner, name, stack)\
        if #self > 0 then
            for i = 1, #self do
                _TypeMap[self[i]]       = target
            end
        else
            local name                  = Namespace.GetNamespaceName(target, true)
            name                        = name:gsub("File$", "")
            _TypeMap[name]              = target
        end
    end

    -------------------------------------------------------
    --                     Property                      --
    -------------------------------------------------------
    property "AttributeTarget" { default = AttributeTargets.Class }

    -------------------------------------------------------
    --                    Constrctor                     --
    -------------------------------------------------------
    __Arguments__{ NEString * 0 }
    function __new(_, ...)
        return { ... }, true
    end
end)

-----------------------------------------------------------
-- File Interfaces
-----------------------------------------------------------
__Sealed__()
interface "IReactiveSource"             (function(_ENV)
    require "File"

    -------------------------------------------------------
    --                      Method                       --
    -------------------------------------------------------
    --- Return the reactive source
    __Abstract__()
    function GetReactiveSource(self) end
end) 

__Sealed__()
interface "IUIElement"                 (function(_ENV)
    require "File"

    -------------------------------------------------------
    --                      Method                       --
    -------------------------------------------------------
    --- Return the UI element
    __Abstract__()
    function GetUIElement(self) end
end)

__Sealed__()
interface "IAnimation"                  (function(_ENV)
    require "File"

    -------------------------------------------------------
    --                      Method                       --
    -------------------------------------------------------
    --- Return the animation
    __Abstract__()
    function GetAnimation(self) end
end)

__Sealed__()
interface "ISkin"                      (function(_ENV)
    require "File"

    -------------------------------------------------------
    --                      Method                       --
    -------------------------------------------------------
    --- Return the skin
    __Abstract__()
    function GetSkin(self) end
end)