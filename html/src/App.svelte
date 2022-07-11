<script lang="ts">
	import {fly} from 'svelte/transition';
	import BoxWithData from './components/BoxWithData.svelte';
	import BoxWithoutData from './components/BoxWithoutData.svelte';
	import CreateNewPlayer from './components/CreateNewPlayer.svelte';
	import {fetchNui} from './utils/fetchNui';
	import spawn from './store/spawnUI';
	import {useNuiEvent} from './utils/useNuiEvent';
	import SCharacter from './store/selectedCharacter';
	import SpawnUi from './components/SpawnUI.svelte';
	import DeleteCharacter from './components/DeleteCharacter.svelte';
	import {onDestroy, to_number} from 'svelte/internal';
	import CreatePlayer from './store/characterList';
	import ModalOnError from './components/ModalOnError.svelte';
	let nPlayer = false; // this will lock the nui on a modal, preventing pointer events
	$: ARR = [0, 1, 2, 3, 4, 5];
	let del = false;
	let container: HTMLDivElement;
	let currentLocation = 'lastlocation';
	const {openCharWindows, charList, openUI, closeOnErrorSpawn} = CreatePlayer;
	$: ss = null;
	$: sw = 0;
	$: jericoFX = '';
	$: cid = 0;
	$:needModel = false
	const newPlayer = (i: number) => {
		cid = i + 1;
		$openCharWindows = true;
		nPlayer = true;
		ss = null;
		sw = 0;
	};
	const closeMDL = () => {
		$openCharWindows = false;
		nPlayer = false;
		sw = 0;
	};
	useNuiEvent('openMulticharacter', ({o, data, nCharacter, spawnData}) => {
		$openUI = o;
		CreatePlayer.setCharacters(data);
		ARR.length = to_number(nCharacter);
		spawn.addNewLocations(spawnData);
		RegisterNewCharacter();
	});
	useNuiEvent('closeNUI', () => {
		ResetAndClose();
		fetchNui('exitMultiplayer');
	});

	useNuiEvent('NewPlayerCoords', ({open, coordinates, newPlayer, data}) => {
		ss = open;
		assign(1);
		jericoFX = data; //preventing null
		spawn.addNewLocations(coordinates, newPlayer);
		needModel = true
	});
	function ResetAndClose() {
		jericoFX = '';
		$openUI = false;
		ss = null;
		sw = 0;
		cid = 0;
		ARR = [0, 1, 2, 3, 4];
		$charList.length = 0;
		nPlayer = false;
		del = false;
		spawn.reset();
	}

	function RegisterNewCharacter() {
		$charList.forEach((element) => {
			ARR[element.cid - 1] = element;
		});
	}

	function onSelectedCitizenid(e: string): void {
		SCharacter.sendSelectedCharacter(e);
		jericoFX = e;
		sw = 0;
		ss = 0;
	}
	const handleSpawn = () => {
		if (jericoFX !== '' && currentLocation !== '') {
			SCharacter.spawnSelectedCharacter(jericoFX, currentLocation, needModel);
		}
	};
	const assign = (i: number) => {
		sw = i;
	};
	const closeDeleteModal = () => {
		del = false;
		ss = null;
	};
	onDestroy(() => {
		ResetAndClose();
	});
</script>

{#if $openUI}
	<div bind:this={container}>
		<CreateNewPlayer {cid} open={$openCharWindows} on:closeModal={closeMDL} />
	</div>
	<div class:no-pointer-events={nPlayer} transition:fly={{x: -15}} class="container absolute-center 			non-selectable fit scroll hide-scrollbar  " style:left="13vw">
		<div class="imagebackground absolute-center " style="width:26vw">
			<img src="img/bgPanel.png" style="width:100%;" alt="asd" />
			<div class="absolute-top scroll hide-scrollbar " style:height="58vh" style:top="4vh">
				<div class="relative-position full-width flex nowrap justify-center items-center align-center column " style:gap={'30px'}>
					{#each ARR as data, i}
						{#if data.charinfo}
							<div on:click={() => (ss = i)}>
								<BoxWithData {onSelectedCitizenid} name={`${data.charinfo.firstname} ${data.charinfo.lastname}`} citizenID={data.charinfo.citizenid} {ss} {i} />
							</div>
						{:else}
							<BoxWithoutData {newPlayer} {i} />
						{/if}
					{/each}
				</div>
			</div>
			<div class="selectedButtons absolute-bottom" style="gap:30px; width:100%;height:10vh;bottom:1vh;">
				<div class="relative-position flex rows  justify-around align-center items-center">
					<img on:click={() => (ss !== null ? (del = true) : (del = false))} class:image-change={ss === null} src=" img/cross.png" alt="" />
				</div>
			</div>
		</div>
	</div>

	{#if del}
		<DeleteCharacter closeNui={closeDeleteModal} citizenid={jericoFX} open={del} />
	{/if}
	{#if $closeOnErrorSpawn}
		<ModalOnError open={$closeOnErrorSpawn} />
	{/if}
{/if}
{#if ss !== null}
	<SpawnUi {handleSpawn} bind:currentLocation {sw} {assign} />
{/if}

<style>
	:global(body) {
		font-family: 'Love Ya Like A Sister', cursive;
	}
	.image-change {
		filter: contrast(0%);
	}
</style>
