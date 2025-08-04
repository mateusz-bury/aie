using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using AIO_API.Data;
using AIO_API.Entities;

namespace AIO_API.Controllers
{
    [Route("api/{characterid}/item")]
    [ApiController]
    public class CharacterItemsController : ControllerBase
    {
        public CharacterItemsController()
        {
        }

        //[HttpPost]
        //public ActionResult Post([FromRoute] int characterId)
        //{
        //}

        //// GET: CharacterItems
        //public async Task<IActionResult> Index()
        //{
        //    var aieDbContext = _context.CharacterItems.Include(c => c.Character).Include(c => c.Item);
        //    return View(await aieDbContext.ToListAsync());
        //}

        //// GET: CharacterItems/Details/5
        //public async Task<IActionResult> Details(int? id)
        //{
        //    if (id == null || _context.CharacterItems == null)
        //    {
        //        return NotFound();
        //    }

        //    var characterItem = await _context.CharacterItems
        //        .Include(c => c.Character)
        //        .Include(c => c.Item)
        //        .FirstOrDefaultAsync(m => m.CharacterId == id);
        //    if (characterItem == null)
        //    {
        //        return NotFound();
        //    }

        //    return View(characterItem);
        //}

        //// GET: CharacterItems/Create
        //public IActionResult Create()
        //{
        //    ViewData["CharacterId"] = new SelectList(_context.PlayableCharacter, "id", "Career");
        //    ViewData["ItemId"] = new SelectList(_context.Items, "Id", "Id");
        //    return View();
        //}

        //// POST: CharacterItems/Create
        //// To protect from overposting attacks, enable the specific properties you want to bind to.
        //// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> Create([Bind("CharacterId,ItemId,Count")] CharacterItem characterItem)
        //{
        //    if (ModelState.IsValid)
        //    {
        //        _context.Add(characterItem);
        //        await _context.SaveChangesAsync();
        //        return RedirectToAction(nameof(Index));
        //    }
        //    ViewData["CharacterId"] = new SelectList(_context.PlayableCharacter, "id", "Career", characterItem.CharacterId);
        //    ViewData["ItemId"] = new SelectList(_context.Items, "Id", "Id", characterItem.ItemId);
        //    return View(characterItem);
        //}

        //// GET: CharacterItems/Edit/5
        //public async Task<IActionResult> Edit(int? id)
        //{
        //    if (id == null || _context.CharacterItems == null)
        //    {
        //        return NotFound();
        //    }

        //    var characterItem = await _context.CharacterItems.FindAsync(id);
        //    if (characterItem == null)
        //    {
        //        return NotFound();
        //    }
        //    ViewData["CharacterId"] = new SelectList(_context.PlayableCharacter, "id", "Career", characterItem.CharacterId);
        //    ViewData["ItemId"] = new SelectList(_context.Items, "Id", "Id", characterItem.ItemId);
        //    return View(characterItem);
        //}

        //// POST: CharacterItems/Edit/5
        //// To protect from overposting attacks, enable the specific properties you want to bind to.
        //// For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        //[HttpPost]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> Edit(int id, [Bind("CharacterId,ItemId,Count")] CharacterItem characterItem)
        //{
        //    if (id != characterItem.CharacterId)
        //    {
        //        return NotFound();
        //    }

        //    if (ModelState.IsValid)
        //    {
        //        try
        //        {
        //            _context.Update(characterItem);
        //            await _context.SaveChangesAsync();
        //        }
        //        catch (DbUpdateConcurrencyException)
        //        {
        //            if (!CharacterItemExists(characterItem.CharacterId))
        //            {
        //                return NotFound();
        //            }
        //            else
        //            {
        //                throw;
        //            }
        //        }
        //        return RedirectToAction(nameof(Index));
        //    }
        //    ViewData["CharacterId"] = new SelectList(_context.PlayableCharacter, "id", "Career", characterItem.CharacterId);
        //    ViewData["ItemId"] = new SelectList(_context.Items, "Id", "Id", characterItem.ItemId);
        //    return View(characterItem);
        //}

        //// GET: CharacterItems/Delete/5
        //public async Task<IActionResult> Delete(int? id)
        //{
        //    if (id == null || _context.CharacterItems == null)
        //    {
        //        return NotFound();
        //    }

        //    var characterItem = await _context.CharacterItems
        //        .Include(c => c.Character)
        //        .Include(c => c.Item)
        //        .FirstOrDefaultAsync(m => m.CharacterId == id);
        //    if (characterItem == null)
        //    {
        //        return NotFound();
        //    }

        //    return View(characterItem);
        //}

        //// POST: CharacterItems/Delete/5
        //[HttpPost, ActionName("Delete")]
        //[ValidateAntiForgeryToken]
        //public async Task<IActionResult> DeleteConfirmed(int id)
        //{
        //    if (_context.CharacterItems == null)
        //    {
        //        return Problem("Entity set 'AieDbContext.CharacterItems'  is null.");
        //    }
        //    var characterItem = await _context.CharacterItems.FindAsync(id);
        //    if (characterItem != null)
        //    {
        //        _context.CharacterItems.Remove(characterItem);
        //    }
            
        //    await _context.SaveChangesAsync();
        //    return RedirectToAction(nameof(Index));
        //}

        //private bool CharacterItemExists(int id)
        //{
        //  return (_context.CharacterItems?.Any(e => e.CharacterId == id)).GetValueOrDefault();
        //}
    }
}
