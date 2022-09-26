<script lang="ts">
	import {fade} from 'svelte/transition';
	import selectedCharacter from '../store/selectedCharacter';
	export let citizenid = '';
	export let open = false;
	export let closeNui = (): void => {};

	const Delete = () => {
		if (citizenid !== '') {
			selectedCharacter.onCharacterDelete(citizenid);
		}
	};
</script>

{#if open}
	<div transition:fade={{duration: 100}} class="modal-overlay non-selectable">
		<div class="my-back fit" />
		<div class="container absolute-center">
			<div class="background">
				<div>
					<img src="img/hud_menu_4a.png" style:width="34vw" alt="" />
					<div class="title absolute-center" style:top="7vh">
						<img src="img/menu_header_1a.png" style:width="20vw" alt="" />
						<div class="title-text absolute-center full-width">
							<p class="full-width text-center justify-center  absolute-center flex text-white text-h4">Delete Character</p>
						</div>
					</div>
				</div>
				<div>
					<div class="confirmation-text absolute-center" style:top="20vh">
						<img src="img/hud_menu_5a.png" style:width="25vw" alt="" />
						<div class="confirm absolute-center fit">
							<p class="full-width text-center justify-center  absolute-center flex text-dark text-h4">Are you sure you want to delete {citizenid} ?</p>
						</div>
					</div>
				</div>
				<div>
					<div class="buttons absolute-bottom full-width" style:height="13vh">
						<div class="relative-position fit flex justify-around items-center">
							<div on:click={closeNui} class="img cancel-button relative-position">
								<img class="" src="img/hud_wanted_bg.png" style:width="12vw" alt="" />
								<img class="absolute-center hideorshow" src="img/toast.png" style:width="12vw" alt="" />
								<p class="text-center absolute-center text-h4">NO</p>
							</div>
							<div on:click={Delete} class=" img add-button relative-position">
								<img class="absolute-center hideorshow" src="img/toast.png" style:width="12vw" alt="" />
								<img src="img/hud_wanted_bg.png" style:width="12vw" alt="" />
								<p class="text-center absolute-center text-h4">YES</p>
							</div>
						</div>
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
