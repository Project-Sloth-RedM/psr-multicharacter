<script lang="ts">
	import {createEventDispatcher} from 'svelte';
	import characterList from '../store/characterList';
	import {fade} from 'svelte/transition';
	const dispatch = createEventDispatcher();
	export let open = false;
	const {closeOnErrorSpawn} = characterList;
</script>

{#if open}
	<div transition:fade={{duration: 100}} class="modal-overlay non-selectable">
		<div class="my-back fit" />
		<div class="container absolute-center">
			<div class="background-image">
				<img src="img/hud_menu_4a.png" style:width="34vw" alt="" />
				<div class="title absolute-center" style:top="7vh">
					<img src="img/menu_header_1a.png" style:width="20vw" alt="" />
					<div class="title-text absolute-center full-width">
						<p class="full-width text-center justify-center  absolute-center flex text-white text-h4">ERROR</p>
					</div>
					<div>
						<div class="confirmation-text absolute-center" style:top="20vh">
							<img src="img/hud_menu_5a.png" style:width="25vw" alt="" />
							<div class="confirm absolute-center fit">
								<p class="full-width text-center justify-center  absolute-center flex text-dark text-h4">Can´t spawn on Last Location please select another one</p>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div on:click={() => (dispatch('onCloseError', {open}), ($closeOnErrorSpawn = false))} class="buttons absolute-bottom" style:height="13vh">
				<div class="relative-position fit flex justify-around items-center">
					<div class="img cancel-button relative-position">
						<img class="" src="img/hud_wanted_bg.png" style:width="12vw" alt="" />
						<img class="absolute-center hideorshow" src="img/toast.png" style:width="12vw" alt="" />
						<p class="text-center absolute-center text-h4">OK</p>
					</div>
				</div>
			</div>
		</div>
	</div>
{/if}

<style>
	.my-back {
		background-color: rgba(255, 255, 55, 0.0001) !important;
	}
	.modal-overlay {
		z-index: 1000;
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background-color: #00000080 !important;
	}
	/* .img:hover img {
		content: url('img/toast.png');
	}
	.img:hover p {
		color: white;
	} */
	.hideorshow {
		opacity: 0;
		visibility: hidden;
		transition: opacity 0.1s ease-in-out;
	}
	.img:hover .hideorshow {
		opacity: 1;
		visibility: visible;
	}
	.img:hover p {
		color: white;
	}
</style>
