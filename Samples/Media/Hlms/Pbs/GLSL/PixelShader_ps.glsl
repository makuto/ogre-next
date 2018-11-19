@insertpiece( SetCrossPlatformSettings )
@property( !GL430 )
@property( hlms_tex_gather )#extension GL_ARB_texture_gather: require@end
@end
@insertpiece( SetCompatibilityLayer )
@insertpiece( DeclareUvModifierMacros )

layout(std140) uniform;
#define FRAG_COLOR		0

@insertpiece( DefaultHeaderPS )

@property( !hlms_render_depth_only )
	@property( !hlms_shadowcaster )
		@property( !hlms_prepass )
			layout(location = FRAG_COLOR, index = 0) out vec4 outColour;
		@end @property( hlms_prepass )
			#define outPs_normals outNormals
			#define outPs_shadowRoughness outShadowRoughness
			layout(location = 0) out vec4 outNormals;
			layout(location = 1) out vec2 outShadowRoughness;
		@end
	@end @property( hlms_shadowcaster )
	layout(location = FRAG_COLOR, index = 0) out float outColour;
	@end
@end

@property( hlms_use_prepass )
	@property( !hlms_use_prepass_msaa )
		uniform sampler2D gBuf_normals;
		uniform sampler2D gBuf_shadowRoughness;
	@end @property( hlms_use_prepass_msaa )
		uniform sampler2DMS gBuf_normals;
		uniform sampler2DMS gBuf_shadowRoughness;
		uniform sampler2DMS gBuf_depthTexture;
	@end

	@property( hlms_use_ssr )
		uniform sampler2D ssrTexture;
	@end
@end

@insertpiece( DeclPlanarReflTextures )
@insertpiece( DeclAreaApproxTextures )

@property( hlms_vpos )
in vec4 gl_FragCoord;
@end

// START UNIFORM DECLARATION
@property( !hlms_shadowcaster || alpha_test )
	@property( !hlms_shadowcaster )
		@insertpiece( PassStructDecl )
	@end
	@insertpiece( MaterialStructDecl )
	@insertpiece( InstanceDecl )
	@insertpiece( PccManualProbeDecl )
@end
@insertpiece( custom_ps_uniformDeclaration )
// END UNIFORM DECLARATION
@property( !hlms_shadowcaster || !hlms_shadow_uses_depth_texture || alpha_test || exponential_shadow_maps )
in block
{
@insertpiece( VStoPS_block )
} inPs;
@end

@property( !hlms_shadowcaster )

@property( hlms_forwardplus )
/*layout(binding = 1) */uniform usamplerBuffer f3dGrid;
/*layout(binding = 2) */uniform samplerBuffer f3dLightList;
@end
@property( irradiance_volumes )
	uniform sampler3D irradianceVolume;
@end

@property( !roughness_map && !hlms_decals_diffuse )#define ROUGHNESS material.kS.w@end
@foreach( num_textures, n )
	uniform sampler2DArray textureMaps@n;@end

@property( !hlms_enable_cubemaps_auto )
	@property( use_envprobe_map )uniform samplerCube		texEnvProbeMap;@end
@end
@property( hlms_enable_cubemaps_auto )
	@property( !hlms_cubemaps_use_dpm )
		@property( use_envprobe_map )uniform samplerCubeArray	texEnvProbeMap;@end
	@end
	@property( hlms_cubemaps_use_dpm )
		@property( use_envprobe_map )uniform sampler2DArray	texEnvProbeMap;@end
		@insertpiece( DeclDualParaboloidFunc )
	@end
@end

@property( (hlms_normal || hlms_qtangent) && !hlms_prepass && needs_view_dir )
	@insertpiece( DeclareBRDF )
	@insertpiece( DeclareBRDF_InstantRadiosity )
	@insertpiece( DeclareBRDF_AreaLightApprox )
@end

@property( use_parallax_correct_cubemaps )
	@insertpiece( DeclParallaxLocalCorrect )
@end

@insertpiece( DeclDecalsSamplers )

@insertpiece( DeclShadowMapMacros )
@insertpiece( DeclShadowSamplers )
@insertpiece( DeclShadowSamplingFuncs )

@insertpiece( DeclAreaLtcTextures )
@insertpiece( DeclAreaLtcLightFuncs )

@insertpiece( custom_ps_functions )

void main()
{
    @insertpiece( custom_ps_preExecution )
	@insertpiece( DefaultBodyPS )
	@insertpiece( custom_ps_posExecution )
}
@else ///!hlms_shadowcaster

@insertpiece( DeclShadowCasterMacros )

@property( alpha_test )
	@foreach( num_textures, n )
		uniform sampler2DArray textureMaps@n;@end
@end

@property( hlms_shadowcaster_point || exponential_shadow_maps )
	@insertpiece( PassStructDecl )
@end

void main()
{
	@insertpiece( custom_ps_preExecution )
	@insertpiece( DefaultBodyPS )
	@insertpiece( custom_ps_posExecution )
}
@end ///hlms_shadowcaster
