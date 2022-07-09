<script lang="ts">
	import {fade} from 'svelte/transition';
	export let sw = 0;
	export let assign = (i: number) => {};
	import Locations from '../store/spawnUI';
	export let currentLocation = '';
	export let handleSpawn = (): void => {};
</script>

<div transition:fade class="spawnPoint absolute-right non-selectable" style:top="3vw">
	<div class="background relative-position">
		<img src="img/spawnBG.svg" style:width="20vw" alt="" />
		<div class="title-spawn absolute-center" style:top="7vw">
			<img src="img/hud_menu_5a.png" style:width="17.5vw" alt="" />
			<p class="absolute-center full-width text-h4 text-center">Select Spawn</p>
		</div>
		<div class="body-spawn-points absolute-top" style:height="45vh" style:top="11vw">
			<div class="relative-position flex colum justify-center align-center items-center nowrap" style:gap={'10px'}>
				{#each $Locations as veh, i}
					<div class="relative-position" on:click={() => (assign(i), (currentLocation = veh.location))}>
						<span class:text-white={sw === i} style:z-index="99" class="absolute-center t full-width text-h4 text-center ellipsis">{veh.label}</span>
						<img src="img/hud_wanted_bg.png" style:width="15vw" alt="" />
						{#if sw === i}
							<img class="absolute-center" src="img/toast.png" style:width="16.8vw" alt="" />
						{/if}
					</div>
				{/each}
			</div>
		</div>
	</div>
	<div on:click={handleSpawn} class="button-accept absolute-center" style:top="42vw">
		<img class="img" src="img/tick.png" alt="" />
	</div>
</div>

<style>
	* {
		font-family: 'Love Ya Like A Sister', cursive;
	}
	.img:hover {
		transform: scale(1.1);
	}
</style>
