<script>
	export let options = [];
	export let selectedOptions = [];
	export let placeholder = 'Select items to search from...';

	const addOption = (option) => {
		if (!selectedOptions.includes(option)) {
			selectedOptions = [...selectedOptions, option];
		}
	};

	const removeOption = (option) => {
		selectedOptions = selectedOptions.filter((o) => o !== option);
	};

	const toggleDropdown = () => {
		const dropdown = document.getElementById('dropdown');
		dropdown.classList.toggle('hidden');
	};
</script>

<div class="relative w-full max-w-md">
	<div class="flex flex-wrap items-center border border-gray-300 rounded-md mt-2 space-x-2">
		{#each selectedOptions as option}
			<span class="flex items-center px-2 py-1 text-sm bg-stanford-dark text-white rounded-full">
				{option.label}
				<button type="button" class="ml-1" on:click={() => removeOption(option)}> &times; </button>
			</span>
		{/each}
		<input
			type="text"
			{placeholder}
			class="block flex-1 border-0 bg-transparent py-1.5 pl-4 text-gray-900 placeholder:text-gray-400 focus:ring-0 sm:text-sm sm:leading-6"
			on:focus={toggleDropdown}
		/>
	</div>

	<div
		id="dropdown"
		class="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-md shadow-lg hidden"
	>
		{#each options as option}
			<div
				class="cursor-pointer px-4 py-2 text-sm hover:bg-gray-100 flex justify-between items-center"
				on:click={() => addOption(option)}
			>
				<span>{option.label}</span>
				{#if selectedOptions.includes(option)}
					<svg
						class="w-5 h-5 text-stanford-dark"
						fill="none"
						stroke="currentColor"
						viewBox="0 0 24 24"
					>
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M5 13l4 4L19 7"
						/>
					</svg>
				{/if}
			</div>
		{/each}
		{#if options.length === 0}
			<p class="px-4 py-2 text-sm text-center text-gray-600">no results found.</p>
		{/if}
	</div>
</div>

<style>
	.hidden {
		display: none;
	}
</style>
