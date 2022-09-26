<script lang="ts">
	import {createEventDispatcher} from 'svelte';
	import {fade} from 'svelte/transition';
	import Buttons from '../lib/Buttons.svelte';
	import InputDate from '../lib/Input-date.svelte';
	import Inputs from '../lib/Inputs.svelte';
	import Selection from '../lib/Selection.svelte';
	export let cid = 0;
	import characterCreation from '../store/characterList';
	const dispatch = createEventDispatcher();
	const {newCharAcceptButton} = characterCreation;
	export let open = false;
	$: newCharacter = {
		firstname: '',
		lastname: '',
		nationality: '',
		gender: 'Male',
		date: new Date(),
		cid: cid,
		newplayer: true,
	};
	$: checkNewName = newCharacter.firstname.length <= 0 || newCharacter.lastname.length <= 0 || newCharacter.nationality.length <= 0;
	$: {
		if (!checkNewName) {
			$newCharAcceptButton = false;
		} else {
			$newCharAcceptButton = true;
		}
	}

	const Create = () => {
		if (!$newCharAcceptButton) {
			characterCreation.createNewCharacter(newCharacter);
		}
	};
	$: console.log(newCharacter);
</script>

{#if open}
	<div transition:fade={{duration: 100}} class="modal-overlay non-selectable">
		<div class="my-back fit" />
		<div class="container absolute-center" style="width:40vw;height:60vh">
			<div class="title absolute-center" style:z-index="99" style:top="4vh">
				<p class=" absolute-center full-width" style="color:white;text-align:center;font-size:2vw;">Character Registration</p>
				<img src="img/bg.png" style:width="30vw" alt="" />
			</div>
			<img class="absolute-center" src="img/buttonp.png" style:width="inherit" alt="" />
			<img class="absolute-center" src="img/buttonv.png" style:width="30vw" alt="" />
			<div class="relative-position  flex justify-center align-center items-center colum" style="gap:1.5vh;height:70%;top:15%;">
				<Inputs bind:returnValue={newCharacter.firstname} placeholder="First Name" />
				<Inputs bind:returnValue={newCharacter.lastname} placeholder="Last Name" />
				<Inputs bind:returnValue={newCharacter.nationality} placeholder="Nationality" />
				<Selection bind:bind={newCharacter.gender} />
				<InputDate bind:date={newCharacter.date} />
			</div>
			<div class="buttons absolute-center" style="width:45vw;height:10vh; top:54vh;">
				<div class="relative-position fit flex row justify-around items-center">
					<Buttons type="cancel" checkEmptyData={false} onClick={() => (dispatch('closeModal'), (open = false))} text="Cancel" />
					<Buttons onClick={Create} checkEmptyData={$newCharAcceptButton} text="Accept" />
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
</style>
