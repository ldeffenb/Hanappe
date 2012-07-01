----------------------------------------------------------------
-- This is a class to manage the Shader. <br>
-- This source has been implemented by Nenad Katic. <br>
-- Has been partially modified. <br>
-- 
-- @auther Nenad Katic
-- @class table
-- @name SceneManager
----------------------------------------------------------------

local ResourceManager = require("hp/manager/ResourceManager")

local M = {}
M.shaders = {}

M.BASIC_COLOR_SHADER = "simpleColor"

local function getFileData(filename)
    local path = ResourceManager:getFilePath(filename)
    local file = assert(io.open(path, mode))
    local data = file:read('*all')
    file:close()
    return data
end

function M:simpleColor()
    if not MOAIGfxDevice.isProgrammable () then
        return
    end
    local shader = MOAIShader.new ()
    local vsh = getFileData("hp/shader/shader_simple.vsh")
    local fsh = getFileData("hp/shader/shader_simple.fsh")
    
    shader:reserveUniforms(2)
    shader:declareUniform(1, 'transform', MOAIShader.UNIFORM_WORLD_VIEW_PROJ )
    shader:declareUniform(2, 'ucolor', MOAIShader.UNIFORM_PEN_COLOR )
    
    shader:setVertexAttribute ( 1, 'position' )
    shader:setVertexAttribute ( 2, 'color' )
    
    shader:load ( vsh, fsh )
    return shader
end


function M:getShader(shaderName)
    if self.shaders[shaderName] then
        return self.shaders[shaderName]
    end
    local shader = self[shaderName](self)
    self.shaders[shaderName] = shader
    return shader
end

return M