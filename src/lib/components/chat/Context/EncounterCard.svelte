<script lang="ts">
	export let className = 'mb-2 h-8 w-8';
	export let strokeWidth = '2';
	export let customStyles = '';
	export let title = 'Encounter Length';

	export let onSelect: () => void;
</script>

<div
	class={customStyles}
	on:click={() => {
		onSelect();
	}}
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
	<span class="text-xs font-medium">{title}</span>
</div>
