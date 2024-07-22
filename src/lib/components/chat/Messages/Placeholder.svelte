<script lang="ts">
	import { WEBUI_BASE_URL } from '$lib/constants';
	import { marked } from 'marked';
	import { config, user, mrnInput, frameworks, loading, chats, formCompleted } from '$lib/stores';
	import { onMount, getContext } from 'svelte';
	import { blur, fade } from 'svelte/transition';
	import Suggestions from '../MessageInput/Suggestions.svelte';
	import { sanitizeResponseContent } from '$lib/utils';
	import Tooltip from '$lib/components/common/Tooltip.svelte';
	import MultiLeveledSelector from '../Context/MultiLeveledSelector.svelte';
	import EncounterCard from '../Context/EncounterCard.svelte';

	const i18n = getContext('i18n');

	export let modelIds = [];
	export let models = [];
	export let submitPrompt;

	let mounted = false;
	let selectedModelIdx = 0;
	let mrn = '';
	let timeframe = '';
	let dataTypes = [];

	$: if (modelIds.length > 0) {
		selectedModelIdx = models.length - 1;
	}

	$: models = modelIds.map((id) => models.find((m) => m.id === id));

	onMount(() => {
		mounted = true;
	});

	const options = [{ label: 'Notes', value: 'notes' }];

	const handleSubmit = async () => {
		loading.set(true);
		setTimeout(() => {
			loading.set(false);
			console.log('Submitted data:', { mrn, timeframe, dataTypes });
			alert(`Your submitted data:\n${JSON.stringify({ mrn, timeframe, dataTypes }, null, 2)}`);
			// Append data to each chat object
			chats.update((chatList) => {
				return chatList.map((chat) => ({
					...chat,
					context: { mrn, timeframe, dataTypes }
				}));
			});
			formCompleted.set(true); // Set form completed flag
		}, 500);
	};
</script>

{#key mounted}
	<div class="m-auto w-full max-w-6xl px-8 lg:px-20 pb-10">
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
							bind:value={mrn}
						/>
					</div>
				</div>
			</div>

			<div class="col-span-3">
				<label for="timeframe" class="block text-sm font-medium leading-6 text-gray-900"
					>Select Timeframe</label
				>
				<!-- <div class="pr-6 py-6 grid grid-cols-2 gap-4">
					{#if timeframe == "Today's Encounter"}
						<EncounterCard
							onSelect={() => {
								timeframe = "Today's Encounter";
								console.log(timeframe);
							}}
							title={"Today's Encounter"}
							customStyles="bg-stanford-dark text-white flex flex-col items-center justify-center rounded-md border border-muted p-4 cursor-pointer"
						/>
					{:else}
						<EncounterCard
							onSelect={() => {
								timeframe = "Today's Encounter";
								console.log(timeframe);
							}}
							title={"Today's Encounter"}
							customStyles="flex flex-col items-center justify-center rounded-md border border-muted p-4 cursor-pointer"
						/>
					{/if}

					<EncounterCard
						onSelect={() => {
							timeframe = '1 Month';
							console.log(timeframe);
						}}
						title={'1 Month'}
						customStyles="flex flex-col items-center justify-center rounded-md border border-muted p-4 cursor-pointer"
					/>
					<EncounterCard
						onSelect={() => {
							timeframe = '1 Year';
							console.log(timeframe);
						}}
						title={'1 Year'}
						customStyles="flex flex-col items-center justify-center rounded-md border border-muted p-4 cursor-pointer"
					/>
					<EncounterCard
						onSelect={() => {
							timeframe = 'All Time';
							console.log(timeframe);
						}}
						title={'All Time'}
						customStyles="flex flex-col items-center justify-center rounded-md border border-muted p-4 cursor-pointer"
					/>
				</div> -->
			</div>

			<div class="col-span-2">
				<label class="block text-sm font-medium text-gray-700">Data Types</label>
				<MultiLeveledSelector {options} bind:selectedOptions={dataTypes} />
			</div>
		</div>
		<button
			on:click={handleSubmit}
			class="mt-4 w-full px-4 py-2 bg-stanford-dark text-white rounded-md">Submit</button
		>
	</div>
{/key}
