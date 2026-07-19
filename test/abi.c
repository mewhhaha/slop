#include <stddef.h>

#include <SDL3/SDL.h>
#include <SDL3_ttf/SDL_ttf.h>

typedef struct SlopABILayout
{
    size_t size;
    size_t alignment;
} SlopABILayout;

#define SLOP_ABI_LAYOUT(type) { sizeof(type), _Alignof(type) }

static const SlopABILayout slop_abi_layouts[] = {
    SLOP_ABI_LAYOUT(SDL_TextInputEvent),
    SLOP_ABI_LAYOUT(SDL_MouseWheelEvent),
    SLOP_ABI_LAYOUT(SDL_FPoint),
    SLOP_ABI_LAYOUT(SDL_Rect),
    SLOP_ABI_LAYOUT(SDL_FRect),
    SLOP_ABI_LAYOUT(SDL_FColor),
    SLOP_ABI_LAYOUT(SDL_GPUTextureSamplerBinding),
    SLOP_ABI_LAYOUT(SDL_GPUStorageBufferReadWriteBinding),
    SLOP_ABI_LAYOUT(SDL_GPUStorageTextureReadWriteBinding),
    SLOP_ABI_LAYOUT(SDL_GPUBufferBinding),
    SLOP_ABI_LAYOUT(SDL_GPUViewport),
    SLOP_ABI_LAYOUT(SDL_GPUVertexBufferDescription),
    SLOP_ABI_LAYOUT(SDL_GPUVertexAttribute),
    SLOP_ABI_LAYOUT(SDL_GPUVertexInputState),
    SLOP_ABI_LAYOUT(SDL_GPUColorTargetBlendState),
    SLOP_ABI_LAYOUT(SDL_GPUColorTargetDescription),
    SLOP_ABI_LAYOUT(SDL_GPUGraphicsPipelineTargetInfo),
    SLOP_ABI_LAYOUT(SDL_GPURasterizerState),
    SLOP_ABI_LAYOUT(SDL_GPUMultisampleState),
    SLOP_ABI_LAYOUT(SDL_GPUStencilOpState),
    SLOP_ABI_LAYOUT(SDL_GPUDepthStencilState),
    SLOP_ABI_LAYOUT(SDL_GPUShaderCreateInfo),
    SLOP_ABI_LAYOUT(SDL_GPUSamplerCreateInfo),
    SLOP_ABI_LAYOUT(SDL_GPURenderStateCreateInfo),
    SLOP_ABI_LAYOUT(SDL_GPUComputePipelineCreateInfo),
    SLOP_ABI_LAYOUT(SDL_GPUGraphicsPipelineCreateInfo),
    SLOP_ABI_LAYOUT(SDL_GPUTextureCreateInfo),
    SLOP_ABI_LAYOUT(SDL_GPUBufferCreateInfo),
    SLOP_ABI_LAYOUT(SDL_GPUTransferBufferCreateInfo),
    SLOP_ABI_LAYOUT(SDL_GPUTextureTransferInfo),
    SLOP_ABI_LAYOUT(SDL_GPUTransferBufferLocation),
    SLOP_ABI_LAYOUT(SDL_GPUTextureRegion),
    SLOP_ABI_LAYOUT(SDL_GPUBufferRegion),
    SLOP_ABI_LAYOUT(SDL_GPUColorTargetInfo),
    SLOP_ABI_LAYOUT(SDL_GPUDepthStencilTargetInfo),
    SLOP_ABI_LAYOUT(SDL_Surface),
    SLOP_ABI_LAYOUT(TTF_GPUAtlasDrawSequence),
};

size_t slop_abi_size(int index)
{
    return slop_abi_layouts[index].size;
}

size_t slop_abi_alignment(int index)
{
    return slop_abi_layouts[index].alignment;
}
