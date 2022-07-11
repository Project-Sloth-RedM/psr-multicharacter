import {writable} from 'svelte/store';
import {fetchNui} from '../utils/fetchNui';
import {isEnvBrowser} from '../utils/misc';
import characterList from './characterList';
import spawnUI from './spawnUI';
interface characterInfo {
	citizenid: string;
}

const store = () => {
	const sCharacter: string = '';
	const {subscribe, set, update} = writable(sCharacter);
	let cache = '';
	return {
		subscribe,
		set,
		update,
		async sendSelectedCharacter(character: string) {
			if (cache !== character) {
				if (!isEnvBrowser()) {
					await fetchNui('selectedCharacter', {citizenid: character});
					cache = character;
				}
			}
		},
		async spawnSelectedCharacter(cid: string, location: string, needmodel?: boolean) {
			if (!isEnvBrowser()) {
				console.log(cid, location);

				await fetchNui('spawnSelectedCharacter', {citizenid: cid, location: location, model: needmodel || false}).then((cb) => {
					if (cb) {
						characterList.openUI.set(false);
					} else {
						characterList.openUI.set(true);
						characterList.closeOnErrorSpawn.set(true);
						console.log('ERROR ON SPAWN');
					}
				});
				cache = '';
			}
		},
		async onCharacterDelete(cid: string) {
			if (!isEnvBrowser()) {
				await fetchNui('deleteCurrentCharacter', {citizenid: cid});
				cache = '';
			}
		},
	};
};
export default store();
