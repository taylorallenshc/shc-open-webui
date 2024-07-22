<script lang="ts">
	import { getContext } from 'svelte';
	import Modal from '$lib/components/common/Modal.svelte';

	const i18n = getContext('i18n');

	export let show = false;
	export let citation;

	let mergedDocuments = [];

	$: if (citation) {
		mergedDocuments = citation.document?.map((c, i) => {
			console.log(c);
			return {
				source: citation.source,
				document: c,
				metadata: citation.metadata?.[i]
			};
		});
	}
</script>

<Modal size="lg" bind:show>
	<div>
		<div class="flex justify-between dark:text-gray-300 px-5 pt-4 pb-2">
			<div>
				<div class="text-xl font-medium self-center capitalize">
					{$i18n.t('Citations')}
				</div>
				<div class="text-sm font-regular text-gray-600">
					{$i18n.t('Relevant citations from the document.')}
				</div>
			</div>
			<button
				class="self-center"
				on:click={() => {
					show = false;
				}}
			>
				<svg
					xmlns="http://www.w3.org/2000/svg"
					viewBox="0 0 20 20"
					fill="currentColor"
					class="w-5 h-5"
				>
					<path
						d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z"
					/>
				</svg>
			</button>
		</div>

		<div class="grid gap-4 py-4 max-h-[400px] overflow-auto px-12">
			{#each mergedDocuments as document, documentIdx}
				<div
					class="grid gap-2 bg-muted/20 p-4 rounded-md cursor-pointer hover:bg-muted/30 transition-colors"
				>
					<div class="flex items-center justify-between">
						<div class="text-sm text-muted-foreground truncate max-w-[200px] text-gray-600">
							{document.source?.name ?? $i18n.t('No source available')}
						</div>
						<div class="flex flex-row gap-4">
							<div class="text-sm text-muted-foreground text-gray-500">
								{document.metadata?.patient ?? $i18n.t('Read More')}
							</div>
						</div>
						<!-- <div class="text-sm text-muted-foreground text-gray-500">
							{document.metadata?.patient ?? $i18n.t('No patient info')}
						</div> -->
					</div>
					<div class="text-xs text-muted-foreground text-gray-500">
						{`Document Length: ${document.document.length} characters`}
					</div>
					<p class="text-sm line-clamp-2">
						{document.document}
					</p>
				</div>
				{#if documentIdx !== mergedDocuments.length - 1}
					<hr class="dark:border-gray-850 my-3 mx-6" />
				{/if}
			{/each}
		</div>

		<div class="flex justify-end p-4">
			<button
				on:click={() => (show = false)}
				class="mt-4 px-4 py-2 bg-stanford-dark text-white rounded-md">Close</button
			>
		</div>
	</div>
</Modal>
