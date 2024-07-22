<script lang="ts">
	import { WEBUI_BASE_URL } from '$lib/constants';
	import { marked } from 'marked';

	import { config, user, models as _models, mrnInput, frameworks, loading } from '$lib/stores';
	import { onMount, getContext } from 'svelte';

	import { blur, fade } from 'svelte/transition';

	import Suggestions from '../MessageInput/Suggestions.svelte';
	import { sanitizeResponseContent } from '$lib/utils';
	import Tooltip from '$lib/components/common/Tooltip.svelte';
	import MultiLeveledSelector from '../Context/MultiLeveledSelector.svelte';

	const i18n = getContext('i18n');

	export let modelIds = [];
	export let models = [];

	export let submitPrompt;

	let mounted = false;
	let selectedModelIdx = 0;

	$: if (modelIds.length > 0) {
		selectedModelIdx = models.length - 1;
	}

	$: models = modelIds.map((id) => $_models.find((m) => m.id === id));

	onMount(() => {
		mounted = true;
	});

	// Context form
	let selectedFrameworks = [];

	const options = [{ label: 'Notes', value: 'notes' }];

	const handleSubmit = async () => {
		loading.set(true);
		setTimeout(() => {
			loading.set(false);
			console.log('Submitted data:', selectedFrameworks);
			alert(`Your submitted data:\n${JSON.stringify(selectedFrameworks, null, 2)}`);
		}, 500);
	};
</script>

{#key mounted}
	<div class="m-auto w-full max-w-6xl px-8 lg:px-20 pb-10">
		<div class="flex justify-start">
			<div class="flex -space-x-4 mb-1" in:fade={{ duration: 200 }}>
				{#each models as model, modelIdx}
					<button
						on:click={() => {
							selectedModelIdx = modelIdx;
						}}
					>
						<Tooltip
							content={marked.parse(
								sanitizeResponseContent(models[selectedModelIdx]?.info?.meta?.description ?? '')
							)}
							placement="right"
						>
							<img
								crossorigin="anonymous"
								src={model?.info?.meta?.profile_image_url ??
									($i18n.language === 'dg-DG'
										? `/doge.png`
										: `${WEBUI_BASE_URL}/static/favicon.png`)}
								class=" size-[2.7rem] rounded-full border-[1px] border-gray-200 dark:border-none"
								alt="logo"
								draggable="false"
							/>
						</Tooltip>
					</button>
				{/each}
			</div>
		</div>

		<div
			class=" mt-2 mb-4 text-3xl text-gray-800 dark:text-gray-100 font-semibold text-left flex items-center gap-4 font-primary"
		>
			<div>
				<div class=" capitalize line-clamp-1" in:fade={{ duration: 200 }}>
					{#if models[selectedModelIdx]?.info}
						{models[selectedModelIdx]?.info?.name}
					{:else}
						{$i18n.t('Hello, {{name}}', { name: $user.name })}
					{/if}
				</div>

				<div in:fade={{ duration: 200, delay: 200 }}>
					{#if models[selectedModelIdx]?.info?.meta?.description ?? null}
						<div
							class="mt-0.5 text-base font-normal text-gray-500 dark:text-gray-400 line-clamp-3 markdown"
						>
							{@html marked.parse(
								sanitizeResponseContent(models[selectedModelIdx]?.info?.meta?.description)
							)}
						</div>
						{#if models[selectedModelIdx]?.info?.meta?.user}
							<div class="mt-0.5 text-sm font-normal text-gray-400 dark:text-gray-500">
								By
								{#if models[selectedModelIdx]?.info?.meta?.user.community}
									<a
										href="https://openwebui.com/m/{models[selectedModelIdx]?.info?.meta?.user
											.username}"
										>{models[selectedModelIdx]?.info?.meta?.user.name
											? models[selectedModelIdx]?.info?.meta?.user.name
											: `@${models[selectedModelIdx]?.info?.meta?.user.username}`}</a
									>
								{:else}
									{models[selectedModelIdx]?.info?.meta?.user.name}
								{/if}
							</div>
						{/if}
					{:else}
						<div class=" font-medium text-gray-400 dark:text-gray-500 line-clamp-1 font-p">
							{$i18n.t('Enter some initial information to start chatting.')}
						</div>
					{/if}
				</div>
			</div>
		</div>
		<div class="grid max-w-sm grid-cols-1 gap-x-6 gap-y-8">
			<div class="col-span-2">
				<label for="mrnInput" class="block text-sm font-medium leading-6 text-gray-900">MRN</label>
				<div class="mt-2">
					<div class="flex rounded-md shadow-sm ring-1 ring-inset ring-gray-300 sm:max-w-md">
						<input
							type="text"
							name="mrnInput"
							id="mrnInput"
							class="block flex-1 border-0 bg-transparent py-1.5 pl-4 text-gray-900 placeholder:text-gray-400 focus:ring-0 sm:text-sm sm:leading-6"
							placeholder="1234567"
						/>
					</div>
				</div>
			</div>

			<div class="col-span-3">
				<label for="about" class="block text-sm font-medium leading-6 text-gray-900"
					>Select Timeframe</label
				>
				<div class="pr-6 py-6 grid grid-cols-2 gap-4">
					<div
						class="flex flex-col items-center justify-center rounded-md border border-muted p-4 hover:bg-gray-100 hover:border-black hover:text-accent-foreground cursor-pointer"
					>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							width="24"
							height="24"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							class="mb-2 h-8 w-8"
						>
							<path d="M8 2v4" />
							<path d="M16 2v4" />
							<rect width="18" height="18" x="3" y="4" rx="2" />
							<path d="M3 10h18" />
						</svg>
						<span class="text-xs font-medium">Today's Encounter</span>
					</div>
					<div
						class="flex flex-col items-center justify-center rounded-md border border-muted p-4 hover:bg-gray-100 hover:border-black hover:text-accent-foreground cursor-pointer"
					>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							width="24"
							height="24"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							class="mb-2 h-8 w-8"
						>
							<path d="M8 2v4" />
							<path d="M16 2v4" />
							<rect width="18" height="18" x="3" y="4" rx="2" />
							<path d="M3 10h18" />
						</svg>
						<span class="text-xs font-medium">1 Month</span>
					</div>
					<div
						class="flex flex-col items-center justify-center rounded-md border border-muted p-4 hover:bg-gray-100 hover:border-black hover:text-accent-foreground cursor-pointer"
					>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							width="24"
							height="24"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							class="mb-2 h-8 w-8"
						>
							<path d="M8 2v4" />
							<path d="M16 2v4" />
							<rect width="18" height="18" x="3" y="4" rx="2" />
							<path d="M3 10h18" />
						</svg>
						<span class="text-xs font-medium">1 Year</span>
					</div>
					<div
						class="flex flex-col items-center justify-center rounded-md border border-muted p-4 hover:bg-gray-100 hover:border-black hover:text-accent-foreground cursor-pointer"
					>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							width="24"
							height="24"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
							class="mb-2 h-8 w-8"
						>
							<path d="M8 2v4" />
							<path d="M16 2v4" />
							<rect width="18" height="18" x="3" y="4" rx="2" />
							<path d="M3 10h18" />
						</svg>
						<span class="text-xs font-medium">All Time</span>
					</div>
				</div>
			</div>

			<div class="col-span-2">
				<label class="block text-sm font-medium text-gray-700">Search Criteria</label>
				<MultiLeveledSelector {options} bind:selectedOptions={selectedFrameworks} />
			</div>
		</div>
		<!-- <div class=" w-full font-primary" in:fade={{ duration: 200, delay: 300 }}>
			<Suggestions
				suggestionPrompts={models[selectedModelIdx]?.info?.meta?.suggestion_prompts ??
					$config.default_prompt_suggestions}
				{submitPrompt}
			/>
		</div> -->
	</div>
{/key}
