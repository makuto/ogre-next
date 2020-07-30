/*
-----------------------------------------------------------------------------
This source file is part of OGRE
    (Object-oriented Graphics Rendering Engine)
For the latest info, see http://www.ogre3d.org/

Copyright (c) 2000-present Torus Knot Software Ltd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
-----------------------------------------------------------------------------
*/
#ifndef _OgreVulkanGlobalBindingTable_H_
#define _OgreVulkanGlobalBindingTable_H_

#include "OgreVulkanPrerequisites.h"

#include "vulkan/vulkan_core.h"

namespace Ogre
{
#define NUM_BIND_CONST_BUFFERS 16u
#define NUM_BIND_TEX_BUFFERS 16u
// We don't use OGRE_MAX_TEXTURE_LAYERS. That's overkill and thus
// reserved for DescriptorSetTextures kind of textures
#define NUM_BIND_TEXTURES 32u
#define NUM_BIND_SAMPLERS 32u

    /// This table holds an emulation of D3D11/Metal style of resource binding
    /// @see    VulkanRootLayout::bind
    struct VulkanGlobalBindingTable
    {
        VkDescriptorBufferInfo paramsBuffer[NumShaderTypes + 1u];
        VkDescriptorBufferInfo constBuffers[NUM_BIND_CONST_BUFFERS];
        VkBufferView texBuffers[NUM_BIND_TEX_BUFFERS];

        VkDescriptorImageInfo textures[NUM_BIND_TEXTURES];
        VkDescriptorImageInfo samplers[NUM_BIND_SAMPLERS];
    };
}  // namespace Ogre

#endif
