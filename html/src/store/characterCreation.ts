import {fetchNui} from '../utils/fetchNui';
import {writable} from 'svelte/store';
import characterList from './characterList';

interface Character {
	firstname: string;
	lastname: string;
	gender: string;
	nationality: string;
	date: Date;
	cid: number;
}
export const openNewCharacterWindow = writable(false);
const store = () => {
	const myNewCharacter: Character = {};
	const {subscribe, set, update} = writable(myNewCharacter);
	const method = {
		async createNewCharacter(data: Character) {
			await fetchNui('createCharacter', data).then((cb) => {
				if (cb) {
					openNewCharacterWindow.set(false);
				}
			});
		},
	};
	return {
		subscribe,
		set,
		update,
		...method,
	};
};
export default store();
